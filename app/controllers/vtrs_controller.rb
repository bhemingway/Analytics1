class VtrsController < ApplicationController
  # GET /vtrs
  # GET /vtrs.json
  def index
    if !params[:search].nil? and !params[:search].empty?
      @vtrs = Vtr.search(params[:search])
    elsif !params[:recno].nil? and !params[:recno].empty?
      @vtrs = Vtr.find(:all,:offset => params[:recno], :limit => 20)
    else
      #@vtrs = Vtr.all
      @vtrs = Vtr.find(:all,:limit => 20)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vtrs }
    end
  end

  # GET /vtrs/1
  # GET /vtrs/1.json
  def show
    @vtr = Vtr.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vtr }
    end
  end

  # GET /vtrs/new
  # GET /vtrs/new.json
  def new
    @vtr = Vtr.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vtr }
    end
  end

  # GET /vtrs/1/edit
  def edit
    @vtr = Vtr.find(params[:id])
  end

  # POST /vtrs
  # POST /vtrs.json
  def create
    @vtr = Vtr.new(params[:vtr])

    respond_to do |format|
      if @vtr.save
        format.html { redirect_to @vtr, notice: 'Vtr was successfully created.' }
        format.json { render json: @vtr, status: :created, location: @vtr }
      else
        format.html { render action: "new" }
        format.json { render json: @vtr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vtrs/1
  # PUT /vtrs/1.json
  def update
    @vtr = Vtr.find(params[:id])

    respond_to do |format|
      if @vtr.update_attributes(params[:vtr])
        format.html { redirect_to @vtr, notice: 'Vtr was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vtr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vtrs/1
  # DELETE /vtrs/1.json
  def destroy
    @vtr = Vtr.find(params[:id])
    @vtr.destroy

    respond_to do |format|
      format.html { redirect_to vtrs_url }
      format.json { head :no_content }
    end
  end

end
