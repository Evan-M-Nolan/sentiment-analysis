import RenderResults from './components/RenderResults';
import Topic from './components/Topic';
import './styling/App.css';

function App() {

  return (
    <div className="App">
      <RenderResults/>
      <Topic name='news'/>
    </div>
  );
}

export default App;
