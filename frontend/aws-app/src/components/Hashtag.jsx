import React, { Component } from 'react'
import '../styling/Hashtag.css'

export default class Hashtag extends Component {
  render() {
    return (
      <div id='HashtagContainer'>
        <div id='SentimentAnalysis'>
            <h3>{this.props.hashtag}</h3>
            <p>{this.props.text}</p>
        </div>
      </div>
    )
  }
}
