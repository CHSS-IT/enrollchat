class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:create, :new]
  before_action :set_section
  before_action :authenticate_user!
  before_action :permitted_to_comment, except: :index

  def index
    @comments = @section.comments.order(created_at: :desc)
    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  # GET /comments/new
  def new
    @comment = Comment.new(section: @section, user: @comment_user)
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        NewCommentWorker.perform_async(@comment.id)
        ActionCable.server.broadcast "department_channel_#{@comment.section.department}",
                                     message: "<a id='comment-notice-" + @comment.section.id.to_s + "' class='dropdown-item' data-toggle='modal' data-target='#comments' data-remote='true' href='/sections/" + @comment.section.id.to_s + "/comments'><i class='fa fa-circle text-info new-message-marker' aria-hidden='true'></i> ".html_safe + @comment.section.section_and_number + ": " + @comment.user.full_name + " at " + @comment.created_at.strftime('%l:%M %P') + ".</a>",
                                     body: @comment.body,
                                     section_name: @comment.section.section_and_number,
                                     user: @comment.user.full_name,
                                     section_id: @comment.section.id,
                                     comment_count: @comment.section.comments.size,
                                     date: @comment.created_at.strftime('%l:%M %P'),
                                     department: @comment.section.department
        ActionCable.server.broadcast "room_channel",
                                     section_id: @comment.section.id,
                                     body: @comment.body,
                                     user: @comment.user.full_name,
                                     comment_count: @comment.section.comments.size,
                                     trigger: 'Refresh'
        format.html { redirect_to sections_url, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
        format.js { flash.now[:notice] = 'Comment was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js { render js: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to section_comment_url, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    ActionCable.server.broadcast "room_channel",
                                 section_id: @comment.section.id,
                                 comment_count: @comment.section.comments.size,
                                 trigger: 'Remove'
    respond_to do |format|
      format.html { redirect_to section_comments_url, notice: 'Comment was successfully destroyed.' }
      format.js { flash.now[:notice] = 'Comment deleted.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_user
      @comment_user = current_user
    end

    def set_section
      @section = Section.find(params[:section_id])
    end

    def permitted_to_comment
      unless current_user.active? || current_user.try(:admin?)
        redirect_to sections_path, notice: 'Unable to post comment. Please contact the administrators to activate your account.'
        return false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :section_id, :body, :section_id)
    end
end
