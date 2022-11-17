import React, { useEffect } from "react";
import { useState } from "react";
import { useInterval } from "../hooks/useInterval";
import {Card} from 'semantic-ui-react';
import { PieChart } from 'react-minimal-pie-chart';
import randomColor from 'randomcolor';


export default function Topic(props) {
    const [topic, setTopic] = useState({startDate: '01/01/2022', endDate: '01/01/2022', smilePercent: 0});
    const [pollCount, setPoll] = useState()
    const {endpoint} =  require('../Utils/topics.json');

    useInterval(() => {
        if (props.polling) {
            setPoll(pollCount+1);
        }
    }, 1000);

    useEffect(() => {
        fetch(endpoint+props.name)
        .then(data => data.json())
        .then(data => {
            let pieData = []
            
            pieData.push({title: 'Smiling: ', value: data.smilePercent*100, color: randomColor({seed: props.name}) })
            pieData.push({title: 'Not smiling: ', value: 100-(data.smilePercent*100), color: randomColor({luminosity: 'light', seed: props.name}) })
            return {
                pieData: pieData,
                startDate: data.startDate,
                endDate: data.endDate
            };
        })
        .then(data => {
            setTopic(data);
        })
    }, [pollCount, props.name, endpoint]);

    return (
            <Card fluid>
                <div style={{padding: "1.5vh"}}>
                    <PieChart label={({ dataEntry }) => dataEntry.title + dataEntry.value + '%'}
                              labelStyle={{"fontSize": 6}}
                              radius={50}
                              data={topic.pieData}
                    />
                </div>
                <Card.Content>
                <Card.Header> {props.name} ({topic.startDate} - {topic.endDate}) </Card.Header>
                    <Card.Description>

                    </Card.Description>
                </Card.Content>
            </Card> 
    );
}