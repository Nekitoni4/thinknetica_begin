module ManufactureCompany
  def company_name(company_name)
    self.company_name = company_name
  end

  protected
  # Думаю, что get метод для получения company_name не нужен так как есть аксессор
  attr_accessor :company_name
end

