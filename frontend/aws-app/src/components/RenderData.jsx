import React from 'react'
import Hashtag from './Hashtag'

export default function RenderData2(props) {
let listOfData = []
props.mapOfHashtags.forEach(function(val, key) {
    listOfData.push(<Hashtag hashtag={key} text={val} />);
})
  return (
    <div>
    {listOfData}
  </div>
  )
}
