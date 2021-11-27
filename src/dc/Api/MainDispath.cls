Class cd.Api.MainDispath Extends dc.Dispatch
{

ClassMethod WithMiddlewares() As %List
{
    return $LB(
    "dc.Middleware.Middleware1", "dc.Middleware.Middleware2", "dc.Middleware.Middleware3"
    )
}

ClassMethod Ping() As %Status
{
    Write { "Say" : "Pong" }.%ToJSON()
    Return $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/ping" Method="GET" Call="Ping" />
</Routes>
}

}
