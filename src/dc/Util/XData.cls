Class dc.Util.XData
{

ClassMethod GetXDataContent(pClass As %String, pXData As %String, Output Content As %XML.XPATH.Document) As %Status
{
    Set urlMap = ##class(%Dictionary.XDataDefinition).%OpenId(pClass_"||"_pXData).Data

    Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(urlMap, .Content)
    Return:$$$ISERR(tSC) tSC

    Return $$$OK
}

ClassMethod GetResultByEvaluateExpression(tDocument As %XML.XPATH.Document, pContext As %String, pExpression As %String, Output listOfObjects As %ListOfObjects) As %Status
{

    Set tSC = tDocument.EvaluateExpression(pContext, pExpression ,.pResults)
    Return:$$$ISERR(tSC) tSC

    Set listOfObjects = ..ConvertXmlResultAttributesToObjectList(pResults)

    Return $$$OK
}

ClassMethod ConvertXmlResultAttributesToObjectList(pResults As %ListOfObjects(CLASSNAME="%XML.XPATH.RESULT")) As %ListOfObjects
{
    Set listOfObjects = ##class(%ListOfObjects).%New()
    For index=1:1:pResults.Count(){
        Set result = pResults.GetAt(index)
        While result.Read(){
            If result.HasAttributes {

                Set objectAttributes = ##class(%Library.DynamicObject).%New()
                For indexObject=1:1:result.AttributeCount {
                    Do result.MoveToAttributeIndex(indexObject)
                    Set $PROPERTY(objectAttributes, result.Name) = result.Value
                }
                Do listOfObjects.Insert(objectAttributes)

            }
        }
    }

    Return listOfObjects
}

}
