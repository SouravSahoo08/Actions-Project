import { useState } from 'react';
import HelpArea from './HelpArea';

function MainContent() {
  const [helpVisible, setHelpVisible] = useState(false);
  const [userInput, setUserInput] = useState('');

  function toggleHelp() {
    setHelpVisible((isVisible) => !isVisible);
  }

  return (
    <main>
      <button onClick={toggleHelp}>
        {helpVisible ? 'Hide' : 'Show'} Help
      </button>

      <input
        type="text"
        placeholder="Enter some text"
        value={userInput}
        onChange={(e) => setUserInput(e.target.value)}
      />

      {/* ❌ INTENTIONAL XSS VULNERABILITY */}
      <div
        dangerouslySetInnerHTML={{
          __html: userInput,
        }}
      />

      {helpVisible && <HelpArea />}
    </main>
  );
}

export default MainContent;
