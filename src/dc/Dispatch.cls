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
    Do ..HandleWithMiddlewares(.pContinue, pUrl, pMethod)

    Quit $$$OK
}

ClassMethod HandleWithMiddlewares(ByRef pContinue As %Boolean, pUrl As %String, pMethod As %String)
{
    Try {

        Set middleware = ##class(dc.Chain.Chain).%New(..GetMiddlewares(pUrl, pMethod))
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

ClassMethod GetMiddlewares(pUrl As %String, pMethod As %String) As %List
{
    Set descriptionMethod = ..GetDescriptionOfMethod(pUrl, pMethod)

    Set globals = ..WithMiddlewares()
    Set:($LISTGET(globals, 1) = "") globals = $LB("")

    Set listSpecifics = ##class(dc.Util.Regex).GetGroups("(?<=\@with_middlewares\().+?(?=\))", descriptionMethod)
    Set:($LISTGET(listSpecifics, 1) = "") listSpecifics = $LB("")
    Set specifics = $LISTFROMSTRING( $LISTTOSTRING( listSpecifics) )

    Set listSkip = ##class(dc.Util.Regex).GetGroups("(?<=\@without_middlewares\().+?(?=\))", descriptionMethod)
    Set:( $LISTGET(listSkip, 1) = "") listSkip = $LB("")
    Set skip = $LISTFROMSTRING( $LISTTOSTRING( listSkip) )

    Set all = $LISTFROMSTRING( $LISTTOSTRING( $LB( $REPLACE( $LISTTOSTRING( globals ) ," ", "" ), $REPLACE( $LISTTOSTRING( specifics ) ," ", "" ) ) ) )

    Set ptr=0
    While $LISTNEXT(all, ptr, value) {
           Set:( $LISTFIND(skip,value) = 0) $LIST(middlewares,*+1) = value
    }

    Return middlewares
}

ClassMethod GetDescriptionOfMethod(pUrl As %String, pMethod As %String) As %String
{
    $$$ThrowOnError(##class(dc.Util.XData).GetXDataContent(..%ClassName(1), "UrlMap", .Content))

    $$$ThrowOnError(##class(dc.Util.XData).GetResultByEvaluateExpression(Content, "/Routes", "Route[@Url='"_pUrl_"' and @Method='"_pMethod_"']", .listOfObjects))

    Return (##class(%Dictionary.MethodDefinition).%OpenId(..%ClassName(1)_"||"_listOfObjects.GetAt(1).Call)).Description
}

}
