Class cd.Api.MainDispatch Extends dc.Dispatch
{

ClassMethod WithMiddlewares() As %List
{
    return $LB(
        "dc.Middleware.Middleware1",
        "dc.Middleware.Middleware2",
        "dc.Middleware.Middleware3"
    )
}

/// @with_middlewares( dc.Middleware.Middleware4, dc.Middleware.Middleware5 )
/// @without_middlewares(dc.Middleware.Middleware1 , dc.Middleware.Middleware2 )
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
