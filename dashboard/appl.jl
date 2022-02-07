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

external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]
app = dash(external_stylesheets=external_stylesheets)
#app = dash()

app.layout = html_div() do
    html_h1("MID validating notebook"),
  
    html_button("Load/update data", id="load_button"),
    html_div(children="No data loaded", id="datastate"),
    
  
    html_h2("Choose a surface to validate"),
    html_div(style = Dict("width" => "600px")) do
        dcc_dropdown(id = "surfacepicker")
    end,
    html_div(id="thumb"),
    html_div(id="dsecompleteness"),
    html_div(id="dseaccuracy"),
    html_div(id="orthography")

end

"Update surfaces menu and set user message about number of times data loaded."
function updaterepodata(n_clicks)
    msg = if isnothing(n_clicks)
        dcc_markdown("*No data loaded yet*")
    elseif n_clicks ==  1
        dcc_markdown("Data loaded.")
    else
        dcc_markdown("""Data loaded **$(n_clicks)** times.""")
    end

    menupairs = [(label="", value="")]
    for s in surfaces(r)
		push!(menupairs, (label=string(s), value=string(s)))
	end
    (msg, menupairs )
end

function updatesurfacedata()
end


callback!(
    updaterepodata,
    app,
    Output("datastate", "children"),
    Output("surfacepicker", "options"),
    Input("load_button", "n_clicks"),
    prevent_initial_call=true
)


callback!(
    
    app,
    Output("thumb", "children"),
    Input("surfacepicker", "value")
) do newsurface
    if isnothing(newsurface) || isempty(newsurface)
        dcc_markdown("")
    else
        thumbhdr = "### 1.A. Verify completeness of indexing\n*Use the linked thumbnail image to see this surface in the Image Citation Tool.*\n\n"
        thumbmarkdown = indexingcompleteness_html(r, Cite2Urn(newsurface), height=150)
        dcc_markdown(thumbhdr * thumbmarkdown)
    end
    
end

run_server(app, "0.0.0.0", debug=true)