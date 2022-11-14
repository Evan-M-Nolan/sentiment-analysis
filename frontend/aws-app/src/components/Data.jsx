import React, { Component } from 'react'
import AWS from 'aws-sdk';
import RenderData from '../components/RenderData'

export default class Data extends Component {

    constructor(props) {
        super(props);
        this.state = {
            mapOfHashtags: new Map()
        };
    }

    componentDidMount() {
        AWS.config.update({
            accessKeyId: process.env.REACT_APP_ACCESS_KEY,
            secretAccessKey: process.env.REACT_APP_SECRET,
        });
        const s3 = new AWS.S3({ region: 'us-east-2' });

        const params = {
            Bucket: 'processed-data-bucket-514-team6',
            Key: `data.csv`,
        };

        s3.getObject(params, (err, data) => {
            if (err) {
                console.log(err, err.stack);
            } else {
                console.log('This data was received from the S3 bucket:\n' + data.Body.toString())
                let receivedData = data.Body.toString().split('\n');
                for (let i = 1; i < receivedData.length; i++) {
                    let item = receivedData[i];
                    let itemArr = item.split(',');
                    if (itemArr[0] !== "") {
                        this.setState({mapOfHashtags: this.state.mapOfHashtags.set(itemArr[0], itemArr[1])})
                        
                    }
                }
            }
        });
    }
    render() {
        return (
            <RenderData mapOfHashtags={this.state.mapOfHashtags} />
        )
    }
}
