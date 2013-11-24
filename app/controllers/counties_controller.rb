class CountiesController < ApplicationController

	def show
		inject_option_headers

		if params[:state_id] && params[:id]
			state, county = get_jurisdiction(params[:state_id],params[:id],page,page_start)
			if params[:pg] && params[:pgStart]
				render json: RestResponse.success(county.cities.paginate(page: params[:pg], per_page: params[:pgStart]))
			else
				render json: RestResponse.success(county.cities.pageinate)
			end
		else	
			RestResponse.notFound('Invalid API query')
		end
	end

	def get_jurisdiction(state,county,page=nil,page_start=nil)
		state = State.where("lower(abbreviation) = ?", state.downcase ).first
		state = State.where(id: state).first unless state
		
		county = County.where(name: county, state_id: state.id).first
		county = County.where(id: county, state_id: state.id).first unless county

		if county
			return [state,county]
		else
			RestResponse.notFound('Invalid API query')
		end
	end
end