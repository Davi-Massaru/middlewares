Class dc.Chain.Middleware Extends dc.Chain.Chain [ Abstract ]
{

Parameter AbortCode = {##class(%CSP.REST).#HTTP401UNAUTHORIZED};

Parameter AbortMessage = "Unauthorized";

Method Abort()
{
    Throw ##class(dc.Exceptions.MiddlewareException).Create(..#AbortCode, ..#AbortMessage)
}

}
