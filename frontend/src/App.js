import Input from './components/Input'
import Topic from './components/Topic'
import './styling/App.css';

function App() {

  return (
    <div className="App">
      <Input/>
      <Topic name="news" />
    </div>
  );
}

export default App;
