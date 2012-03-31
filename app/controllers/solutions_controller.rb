class SolutionsController < ApplicationController
  before_filter(:only => [:create]) { |c| c.require_permission :normal_user }
  before_filter(:only => [:delete]) {|c| c.the_author_himself(@desire, true, true)}

  def create
    @desire = Desire.find(params[:id])

    solution = @desire.solutions.new(params[:solution])
    solution.author = current_user

    respond_to do |format|
      if solution.save
        @desire.admirers .each do |admirer|
          NotificationsManager.generate_for_item(admirer, current_user, @desire, "solve", 0, solution.content) if admirer != current_user
        end
        NotificationsManager.generate_for_item(@desire.author, current_user, @desire, "solve", 0, solution.content ) if @desire.author != current_user

        format.html { redirect_to @desire, notice: t("notices.solution_created") }
      else
        format.html { redirect_to @desire, notice: t("notices.solution_creation_failed") }
      end
    end
  end

  def destroy
    @solution = Solution.find(params[:id])
    @solution.destroy

    respond_to do |format|
      format.html { redirect_to desires_url }
      format.json { head :ok }
    end
  end

end