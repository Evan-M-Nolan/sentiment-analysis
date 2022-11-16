import Topic from './Topic';
import RenderResults from './RenderResults';
import {Card, Header, Icon} from 'semantic-ui-react';
import './../styling/Dashboard.css';
import topicJson from './../Utils/topics.json';

export default function Dashboard(props){

    let topic_list = topicJson.topics;
    let topics = []

    topic_list.forEach((item)=>{
        topics.push(<Topic key={item} name={item}/>)
    })

    return (
        <div>
            <Header style={{paddingTop: "5rem"}} as='h2' icon>
                <Icon name='video' />
                Short Video Analysis
            </Header>
            <div className={"topics-width"}>
                <RenderResults />
            </div>
            <Card.Group className={"topics-width"} centered itemsPerRow={3}>
                {topics}
            </Card.Group>
        </div>
    );
}