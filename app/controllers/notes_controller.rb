class NotesController < ApplicationController
  before_action :set_locale  # Este es el before_action para configurar el idioma
  before_action :set_note, only: %i[ show edit update destroy ]

  def index
    @notes = Note.order(created_at: :desc)

    # Filtrar por título si está presente
    @notes = if params.dig(:filters, :title).present?
      Note.where("title ILIKE ?", "%#{params.dig(:filters, :title)}%")
    else
      Note.all
    end

    # Aplicar ordenamiento según el parámetro `sort`
    case params[:sort]
    when 'newest'
      @notes = @notes.order(created_at: :desc)
    when 'oldest'
      @notes = @notes.order(created_at: :asc)
    when 'az'
      @notes = @notes.order(title: :asc)
    when 'za'
      @notes = @notes.order(title: :desc)
    end

    @notes
  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to root_path, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to root_path, notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end

  # Este es el nuevo método que configura el idioma
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
