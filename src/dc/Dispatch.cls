Class dc.Dispatch Extends %CSP.REST [ Abstract ]
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

ClassMethod WithMiddlewares() As %List
{
    Return $LB()
}

ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    Do ..HandleWithMiddlewares(.pContinue)

    Quit $$$OK
}

ClassMethod HandleWithMiddlewares(ByRef pContinue As %Boolean)
{
    Try {

        Set listMiddlewares = ..WithMiddlewares()

        Set middleware = ##class(dc.Chain.Chain).%New(..WithMiddlewares())
        Do middleware.Handle()
    }
    Catch exception {

        IF exception.%IsA( ##class(dc.Exceptions.MiddlewareException).%ClassName(1) ) {
            Set pContinue = 0
            Set %response.ContentType = ..#CONTENTTYPEJSON
            Set %response.Status = exception.StatusCode
            Write { "Message" : (exception.Name) }.%ToJSON()
            Quit
        }

        Throw exception
    }
}

}
