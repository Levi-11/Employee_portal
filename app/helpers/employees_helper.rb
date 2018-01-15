module EmployeesHelper
    def gravatar_for(employee)
     gravatar_id = Digest::MD5::hexdigest(employee.email.downcase)
     gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
     image_tag(gravatar_url, alt: employee.name, class: "gravatar")
    end

    def date_converter(dates)
        birthday = dates.split('/')
        birthday[0], birthday[1] = birthday[1], birthday[0]
        birthday.join('/')
    end
end
