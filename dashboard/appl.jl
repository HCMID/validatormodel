using Pkg
if  ! isfile("Manifest.toml")
    Pkg.activate(".")
    Pkg.instantiate()
end

using Dash
using CitableBase
using CitableText
using CitableCorpus
using CitableObject
using CitableImage
using CitablePhysicalText
using CitableTeiReaders
using EditionBuilders
using Orthography
using EditorsRepo


r = repository(pwd())
function ict()
	"http://www.homermultitext.org/ict2/?"
end
function iiifsvc()
	IIIFservice("http://www.homermultitext.org/iipsrv",
	"/project/homer/pyramidal/deepzoom")
end

#=
function surfacemenu()
	options = [""]
	for s in surfaces(r)
		push!(options, string(s))
	end
	options
end
=#
app = dash()

app.layout = html_div() do
    html_h1("MID validating notebook"),
    html_div() do 
        "Loaded repository: $(r isa EditingRepository)"
    end,
    dcc_radioitems(
        id = "surface",
        options = [(label = "Select a surface", value = "")],
        value = ""
    )

end


run_server(app, "0.0.0.0", debug=true)