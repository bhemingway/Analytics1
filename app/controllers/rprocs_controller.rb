class RprocsController < ApplicationController
  # GET /rprocs
  # GET /rprocs.json
  def index
    @rprocs = Rproc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rprocs }
    end
  end

  # GET /rprocs/1
  # GET /rprocs/1.json
  def show
    @rproc = Rproc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rproc }
    end
  end

  # GET /rprocs/new
  # GET /rprocs/new.json
  def new
    @rproc = Rproc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rproc }
    end
  end

  # GET /rprocs/1/edit
  def edit
    @rproc = Rproc.find(params[:id])
  end

  # POST /rprocs
  # POST /rprocs.json
  def create
    @rproc = Rproc.new(params[:rproc])

    respond_to do |format|
      if @rproc.save
        format.html { redirect_to @rproc, notice: 'Rproc was successfully created.' }
        format.json { render json: @rproc, status: :created, location: @rproc }
      else
        format.html { render action: "new" }
        format.json { render json: @rproc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rprocs/1
  # PUT /rprocs/1.json
  def update
    @rproc = Rproc.find(params[:id])

    respond_to do |format|
      if @rproc.update_attributes(params[:rproc])
        format.html { redirect_to @rproc, notice: 'Rproc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rproc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rprocs/1
  # DELETE /rprocs/1.json
  def destroy
    @rproc = Rproc.find(params[:id])
    @rproc.destroy

    respond_to do |format|
      format.html { redirect_to rprocs_url }
      format.json { head :no_content }
    end
  end
end
