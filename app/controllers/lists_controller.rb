class ListsController < ApplicationController
  before_action :set_list, only: %i[ show edit update destroy ]

  # GET /lists or /lists.json
  def index
    @lists = List.order(completed: :asc, created_at: :desc)
  end

  # GET /lists/1 or /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists or /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @list.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: "List was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @list.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to lists_path, notice: "List was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

def toggle
  @list = List.find(params[:id])
  @list.update(completed: !@list.completed)

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        "list_#{@list.id}",
        partial: "lists/list_card",
        locals: { list: @list }
      )
    end
    format.html { redirect_to lists_path }
  end
end

# Add this action to clear out completed tasks
def clear_completed
  List.where(completed: true).destroy_all
  redirect_to lists_path, status: :see_other, notice: "Completed tasks were successfully cleared."
end

# Make sure your existing destroy action looks exactly like this:
def destroy
  @list = List.find(params[:id])
  @list.destroy
  
  respond_to do |format|
    format.html { redirect_to lists_path, status: :see_other, notice: "Task was successfully deleted." }
    format.json { head :no_content }
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list).permit(:description, :completed, :priority) # <-- Added :priority here
    end

  end
