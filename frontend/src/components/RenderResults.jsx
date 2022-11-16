import React, { useState, useCallback } from 'react'
import InputGroup from 'react-bootstrap/InputGroup';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Modal from 'react-bootstrap/Modal'
import Topic from '../components/Topic';
import '../styling/RenderResults.css'
export default function RenderResults(props) {
  const [input, setInput] = useState("");
  const [topic, setTopic] = useState("");
  const [show, setShow] = useState(false);

  const onClick = useCallback(() => {
    setTopic(input)
    handleShow()
  },[input])


    const handleClose = () => setShow(false);
    const handleShow = () => setShow(true);
  
    return (
        <>
      <InputGroup className="w-50" size="lg">
        <Form.Control
          placeholder="topic"
          onChange={e => setInput(e.target.value)}
        />
        <Button variant="primary" type="submit" onClick={onClick}>
        Search
      </Button>
      </InputGroup>
  
        <Modal 
        show={show} 
        onHide={handleClose}
        dialogClassName = 'modal-width'
        >
          <Modal.Header closeButton>
            <Modal.Title>Analysing: {topic}</Modal.Title>
          </Modal.Header>
          <Modal.Body>Here are the results: </Modal.Body>
          <Topic name={topic}/>
          <Modal.Footer>
            <Button variant="secondary" onClick={handleClose}>
              Close
            </Button>
          </Modal.Footer>
        </Modal>
      </>
    )
}
