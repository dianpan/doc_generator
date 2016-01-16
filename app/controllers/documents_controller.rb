class DocumentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @document = Document.new
    @documents = current_user.documents.all
  end

  def new
    @document = Document.new
  end

  def create
    document = Document.new(documents_params)
    document.user_id = current_user.id
    pdf = DocPdf.new(document, view_context)
    file_name = "loan_document_#{current_user.id}.pdf"
    pdf.render_file(file_name)
    document.file = File.open(file_name)

    if document.save
      flash[:success] = "Success, document has been created!"
      redirect_to documents_path
    else
      render :new
    end

  end

  private
    def documents_params
      params.require(:document).permit(:loan_amount, :down_payment, :interest_rate)
    end
end
