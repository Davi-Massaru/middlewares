Class dc.Middleware.Middleware3 Extends dc.Chain.Middleware
{

Parameter AbortMessage = "custom message";

Method Handle()
{
    Do ..Abort()
    Do ..Next()
}

}
