Class dc.Util.Regex
{

ClassMethod GetGroups(pRegex As %String, pString As %String) As %List
{

    Set matcher = ##class(%Regex.Matcher).%New(pRegex, pString)

    SET occurrence = $LB()
    while matcher.Locate() {
        SET $LIST(occurrence,*+1) = matcher.Group
    }
    
    Return occurrence
}

}
