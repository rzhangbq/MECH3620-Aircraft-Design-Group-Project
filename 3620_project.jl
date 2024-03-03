### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ 6b378b10-d556-11ee-29e6-0be9ad4cd778
begin
	""" These are variables """
	CD = 0
	L = 0
	L/D = 0
	g = 9.81
	Wpayload = 1100g #in N
	Wcrew = 200g 	  #in N
	Cruise_speed = 810*1000/3600 #in m/s
	LD_max = 16
	R1 = 2159.827*1852 #in meter
	Cruise_altitude = 13700 #in meter
end;

# ╔═╡ d9242117-c511-48cd-8618-99db30cdb48a
begin
	""" The following are variables used in Initial weight estimation """
	takeoffFF = 0.97
	climbFF = 0.985
	cruise_SFC = 0.0000129*g
	landingFF = 0.995
end;

# ╔═╡ 5363cf20-e783-4760-a579-7c0014744f2f
cruise_weight_fraction(R,SFC,V,LtoD) = exp(-R*SFC/(V*LtoD))

# ╔═╡ 4093d5a2-a9fb-4930-8cd1-878a75c30a60
begin
	"""The following are the code used in weight estimation """
	LD_cruise = LD_max * 0.866;  # L/D ratio at cruise
end;

# ╔═╡ 1ff72358-00b0-43c7-8981-defcf8f67797
empty_weight_raymer(WTO, A, B) = A * WTO^B

# ╔═╡ 7109ea8d-7ab6-4cf6-986d-b91c946e49b6
maximum_takeoff_weight(WPL, Wcrew, WfWTO, WeWTO) = (WPL + Wcrew)/(1 - WfWTO - WeWTO)

# ╔═╡ 12533352-8f97-44f4-80da-3b6e441d205b
A, B = 1.07, -0.06

# ╔═╡ 15a846c8-74b5-4768-be31-0e879912007c
Wf_man = 1.06 * (1 - takeoffFF * climbFF * cruise1FF * landingFF)

# ╔═╡ 1e7c02a2-9fb2-43a6-88de-35f2de6ede51
function compute_maximum_takeoff_weight(
		W_0, W_PL, W_crew, WfWTO, A, B; # Input arguments
		# Named default arguments
		num_iters = 50, # Number of iterations
		tol = 1e-12 	# Convergence tolerance
	)
	
	# Initial value of maximum takeoff weight (WTO) from guess
	WTO = W_0
	
	# Array of takeoff weight values
	WTOs = [WTO]
	
	# Array of errors over iterations of size num_iters, initially infinite
	errors = [ Inf; zeros(num_iters) ]
	
	# Iterative loop
	for i in 2:num_iters
		# Calculate empty weight fraction
		WeWTO = empty_weight_raymer(WTO, A, B)
		
		# Calculate new WTO with the calculated empty weight fraction
		new_WTO = maximum_takeoff_weight(W_PL, W_crew, WfWTO, WeWTO)
		
		# Evaluate relative error
		error = abs((new_WTO - WTO)/WTO)

		# Append new WTO to WTOs array
		push!(WTOs, new_WTO)
		
		# Assign error to errors array at current index
		errors[i] = error
		
		# Conditional
		if error < tol					
			break # Break loop
		else
			# Assign new takeoff weight to WTO
			WTO = new_WTO
		end
	end
	
	# Return arrays of takeoff weights and errors 
	WTOs, errors[1:length(WTOs)]
end

# ╔═╡ d0a5473b-b8cd-420c-b107-f1c4cbbbaeb3
WTOs, erros = compute_maximum_takeoff_weight(7500g, Wpayload, Wcrew, Wf_man, A, B)

# ╔═╡ 8f36e62f-5db3-4670-970e-5860670ed5b7
Wcrew

# ╔═╡ 5e23c4ec-2325-4236-b22e-3dd5f9e4e8db


# ╔═╡ 1f18d5b5-efab-4313-81e0-9237816e4e01


# ╔═╡ ac44120c-11c4-4c48-8571-b30f26125844
# ╠═╡ disabled = true
#=╠═╡
cruise1FF = cruise_weight_fraction(R1, cruise_SFC, Cruise_speed, LD_cruise)
  ╠═╡ =#

# ╔═╡ 497b7ce9-6bf0-48c7-b12f-37d101ed8009
cruise1FF = 0.85

# ╔═╡ Cell order:
# ╠═6b378b10-d556-11ee-29e6-0be9ad4cd778
# ╠═d9242117-c511-48cd-8618-99db30cdb48a
# ╠═5363cf20-e783-4760-a579-7c0014744f2f
# ╠═4093d5a2-a9fb-4930-8cd1-878a75c30a60
# ╠═ac44120c-11c4-4c48-8571-b30f26125844
# ╠═1ff72358-00b0-43c7-8981-defcf8f67797
# ╠═7109ea8d-7ab6-4cf6-986d-b91c946e49b6
# ╠═12533352-8f97-44f4-80da-3b6e441d205b
# ╠═497b7ce9-6bf0-48c7-b12f-37d101ed8009
# ╠═15a846c8-74b5-4768-be31-0e879912007c
# ╠═1e7c02a2-9fb2-43a6-88de-35f2de6ede51
# ╠═d0a5473b-b8cd-420c-b107-f1c4cbbbaeb3
# ╠═8f36e62f-5db3-4670-970e-5860670ed5b7
# ╠═5e23c4ec-2325-4236-b22e-3dd5f9e4e8db
# ╠═1f18d5b5-efab-4313-81e0-9237816e4e01
