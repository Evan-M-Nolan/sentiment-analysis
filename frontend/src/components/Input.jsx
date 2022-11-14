import React, { Component } from 'react'
import Button from 'react-bootstrap/Button';

export default class Input extends Component {
    constructor(props) {
        super(props);
        this.state = {value: ''};
    
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
      }
    
      handleChange(event) {
        this.setState({value: event.target.value});
      }
    
      handleSubmit(event) {
        alert('A name was submitted: ' + this.state.value);
        event.preventDefault();
      }
    
      render() {
        return (
          <form onSubmit={this.handleSubmit}>
            <label style={{fontFamily: 'Bowlby One SC, cursive'}}>
              Subscribe:
              <input type="text" value={this.state.value} onChange={this.handleChange} />
            </label>
            <Button variant="primary">Submit</Button>
          </form>
        );
      }
}
