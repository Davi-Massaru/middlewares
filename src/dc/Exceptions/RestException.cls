Class dc.Exceptions.RestException Extends %Exception.AbstractException
{

Property StatusCode As %String;

ClassMethod Create(pStatusCode As %String, pName As %String = "", pCode As %String = "", pLocation As %String = "", pData As %String = "", pInnerException As %Exception.AbstractException = {$$$NULLOREF}) As dc.Exceptions.RestException
{
    Set restException = ..%New(pName,pCode,pLocation,pData,pInnerException)
    Set restException.StatusCode = pStatusCode
    Return restException
}

}
