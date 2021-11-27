Class dc.Chain.Chain Extends %RegisteredObject
{

Property NextChain As dc.Chain.Chain;

Method %OnNew(pListChain As %List = {$LB("")}) As %Status
{
    Set chain = $LISTGET(pListChain, 1, "")
    Set pListChain = $LIST(pListChain,2,*)
    
    Set:'(chain = "") ..NextChain = $CLASSMETHOD(chain,"%New", pListChain)
    Return $$$OK
}

Method Handle()
{
    Do ..Next()
}

Method Next()
{
    Do:($ISOBJECT(..NextChain)) $METHOD(..NextChain, "Handle")
}

}
