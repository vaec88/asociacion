class ParametersDescriptionsController < ApplicationController
  def destroy
    @param_descrip = ParametersDescription.find(params[:description_id])
    #@param_val.parameters_descriptions.find(params[:id])
    @param_descrip.destroy
    #@det.destroy
    redirect_to index_description_path
  end
end
