module Phlex::PDF::Rails
  module Helpers
    # Sends a PDF to the browser via Rails controllers.
    def send_pdf(pdf, disposition: "inline", type: "application/pdf", **kwargs)
      send_data(
        pdf.to_pdf,
        disposition: disposition,
        type: type,
        **kwargs
      )
    end
  end
end