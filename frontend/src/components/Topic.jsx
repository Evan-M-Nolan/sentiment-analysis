import React, { useEffect } from "react";
import { useState } from "react";
import { useInterval } from "../hooks/useInterval";
import Card from 'react-bootstrap/Card';
import { PieChart } from 'react-minimal-pie-chart';
import randomColor from 'randomcolor';


export default function Topic(props) {
    const [topic, setTopic] = useState({startDate: '01/01/2022', endDate: '01/01/2022', smilePercent: 0});
    const [pollCount, setPoll] = useState()

    useInterval(() => {
        if (props.polling) {
            setPoll(pollCount+1);
        }
    }, 1000);

    useEffect(() => {
        fetch('https://jfbyux5iuh.execute-api.us-east-1.amazonaws.com/dev/search?search='+props.name)
        .then(data => data.json())
        .then(data => {
            let pieData = []
            
            pieData.push({title: 'Smiling: ', value: data.smilePercent*100, color: randomColor() })
            pieData.push({title: 'Not smiling: ', value: 100-(data.smilePercent*100), color: randomColor() })
            return {
                pieData: pieData,
                startDate: data.startDate,
                endDate: data.endDate
            };
        })
        .then(data => {
            setTopic(data);
        })
    }, [pollCount]);

    return (
        <div style={{padding: 16}}>
            <Card style={{width: '40vw'}}>
                <Card.Body>
                <Card.Title> {props.name} ({topic.startDate} - {topic.endDate}) </Card.Title>
                    <Card.Text>
                        <PieChart label={({ dataEntry }) => dataEntry.title + dataEntry.value + '%'} 
                        labelStyle={{"font-size": 6}}
                        radius={50} 
                        data={topic.pieData}/>
                    </Card.Text>
                </Card.Body>
            </Card> 
        </div>
    );
}