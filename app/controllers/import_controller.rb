class ImportController < ApplicationController
  def import
    parsed = parse pdf params[:file]

    obj = find_or_create parsed

    if obj.new_record?
      if obj.save
        render json: obj, status: :created, location: obj
      else
        render json: obj.errors, status: :unprocessable_entity
      end
    else
      render json: obj, status: :found, location: obj
    end
  end

  private

  # extract class

  def pdf(file)
    reader = PDF::Reader.new(file.tempfile)
    {
      title: reader.info[:Title],
      page_text: reader.page(1).text
    }
  end

  TOPTAL_REGEX = %r{position .* for (?<company>.*?), .*Paid \$(?<value>\d{1,}\.\d{2}) with Toptal Payments on (?<date>\w+\W\d{1,2}, \d{4})}m
  def parse_toptal(page_text)
    raise "This Toptal invoice doesn't seem to be paid" unless page_text =~ /Paid .* with Toptal Payments/

    matches = page_text.match(TOPTAL_REGEX)
    {
      type: :payment,
      value: matches[:value].to_f,
      date: Date.parse(matches[:date]),
      company: matches[:company]
    }
  end

  TRANSFER_REGEX = %r{Data Operação:.*(?<date>\d{2}\/\d{2}\/\d{4}).*Valor Total MN:.*R\$ (?<value>(\d{1,3}.)*\d{1,3},\d{2}).*Natureza}m
  def parse_transfer(page_text)
    matches = page_text.match(TRANSFER_REGEX)
    {
      type: :transfer,
      value: matches[:value].sub('.', '').sub(',', '.').to_f,
      date: Date.parse(matches[:date])
    }
  end

  def parse(pdf)
    parsed = if pdf[:title].match? /^Toptal - Notice of Payment #\d{1,}$/
      parse_toptal pdf[:page_text]
    elsif pdf[:title] == 'rptResumoBoleto'
      parse_transfer pdf[:page_text]
    end
  end

  def find_or_create(parsed)
    case parsed[:type]
    when :payment
      company = Company.find_or_create_by(name: parsed[:company])
      Payment.where(value: parsed[:value], date: parsed[:date], company: company).first_or_initialize
    when :transfer
      Transfer.where(value: parsed[:value], date: parsed[:date]).first_or_initialize
    when :invoice
      Invoice.where(value: parsed[:value], date: parsed[:date], received: parsed[:received]).first_or_initialize
    end
  end
end
