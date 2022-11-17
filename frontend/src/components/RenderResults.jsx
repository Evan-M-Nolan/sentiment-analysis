import React, { useState, useCallback } from 'react'
import {Modal, Button, Input} from 'semantic-ui-react';
import Topic from '../components/Topic';
import './../styling/RenderResults.css';

export default function RenderResults(props) {
    const {endpoint} =  require('../Utils/topics.json');
    const [input, setInput] = useState("");
    const [topic, setTopic] = useState("");
    const [show, setShow] = useState(false);

    const onSearch = useCallback(() => {
        setTopic(input)
        showModal()
    },[input])

    const sendTopic = () => {
        fetch(endpoint + 'video_search?search=' + input, {
            method: 'POST',
            mode: 'cors',
        })
    }

    const onEnter = (e) => {
        if (e.key === 'Enter'){
            onSearch()
            sendTopic()
        }
    }

    const handleClose = () => setShow(false);
    const showModal = () => setShow(true);

    return (
        <>
            <Input
                className="w-50"
                placeholder="topic"
                icon={{ name: 'search', circular: true, link: true }}
                onKeyDown={onEnter}
                onChange={e => setInput(e.target.value)}
                size={'big'}
            >
            </Input>

            <Modal
                className={"modal-width"}
                open={show}
            >
                <Modal.Header>
                  Analysing: {topic}
                </Modal.Header>
                <Modal.Content>
                    <Topic name={topic} polling={true}/>
                </Modal.Content>

                <Modal.Actions>
                    <Button variant="secondary" onClick={handleClose}>
                        Close
                    </Button>
                </Modal.Actions>
            </Modal>
        </>
    )
}
