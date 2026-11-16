'use strict';
(() => {
  const $ = id => document.getElementById(id);
  const routes = {
    claude: {
      title: '설정 → Your Claude → Instructions',
      detail: '구 화면에서는 Account → Instructions for Claude입니다. 아래 지침을 이 설정란에 붙여 넣으면 계정의 대화에 적용됩니다. 업무별 목적과 자료는 Projects의 프로젝트 지침에 넣으세요.',
      url: 'https://support.claude.com/en/articles/10185728-understanding-claude-s-personalization-features',
      skill: '파일 생성·코드 실행 설정을 켠 뒤 Customize → Skills에서 업로드하고 활성화하세요. 조직 계정은 관리자 설정도 확인하세요. 교정 예시 ZIP은 이 화면에 올릴 수 있습니다.',
      skillUrl: 'https://support.claude.com/en/articles/12512180-use-skills-in-claude'
    },
    cowork: {
      title: '전체 지침과 프로젝트 지침을 나누세요',
      detail: '새 Claude 환경에서는 Cowork의 Global instructions가 설정 → Your Claude → Instructions로 합쳐집니다. 업무별 지침은 해당 Project에서 관리하세요. 연결한 폴더 접근 권한과 계정에 보이는 화면을 확인하세요.',
      url: 'https://support.claude.com/en/articles/16761823-claude-cowork-and-chat-are-one-claude',
      skill: 'Customize → Skills에서 필요한 스킬을 켜세요. 교정 예시 ZIP을 업로드할 때는 파일 생성·코드 실행 설정과 조직의 허용 여부를 확인하세요.',
      skillUrl: 'https://support.claude.com/en/articles/12512180-use-skills-in-claude'
    },
    chatgpt: {
      title: '개인화의 맞춤 지침부터 시작하세요',
      detail: '설정의 Personalization(개인화)에서 맞춤 지침을 관리합니다. 특정 업무에만 적용할 내용은 해당 Project의 지침에 넣으세요. 로컬 폴더에 연결된 데스크톱 환경이라면 선택한 기기의 AGENTS.md 설정을 사용할 수도 있습니다.',
      url: 'https://learn.chatgpt.com/docs/personalize',
      skill: 'ChatGPT Work에서는 @skill-creator, 데스크톱에서는 Skills 기능을 확인하세요. 플러그인에 포함된 스킬과 로컬 스킬의 사용 범위가 다릅니다. 아래 ZIP을 Claude와 같은 메뉴에 업로드한다고 가정하지 마세요. 내용 보기의 교정 절차를 전달해 현재 환경에 맞게 만들도록 요청하세요. 해당 기능이 없으면 반복 요청문으로 보관하세요.',
      skillUrl: 'https://learn.chatgpt.com/docs/build-skills'
    },
    'claude-code': {
      title: '프로젝트의 CLAUDE.md에 필요한 내용만',
      detail: '데스크톱 Code 탭과 CLI에서 프로젝트 폴더의 지침을 사용합니다. 기존 CLAUDE.md를 먼저 비교하고 합치세요. 전체 프로젝트에 공통으로 적용할 지침은 ~/.claude/CLAUDE.md에서 관리합니다. /memory로 확인·편집하고 /context로 읽은 지침을 확인하세요.',
      url: 'https://code.claude.com/docs/en/memory',
      skill: '교정 ZIP을 풀어 proofread 폴더를 프로젝트의 .claude/skills/에 두세요. 기존 같은 이름의 스킬이 있으면 먼저 비교하세요. 새 세션에서 /proofread와 교정할 글을 입력해 시험하세요.',
      skillUrl: 'https://code.claude.com/docs/en/skills'
    },
    codex: {
      title: '프로젝트의 AGENTS.md부터 확인하세요',
      detail: '전체 기본 지침은 ~/.codex/AGENTS.md, 프로젝트 지침은 작업 폴더의 AGENTS.md로 관리합니다. AGENTS.override.md가 있으면 우선할 수 있습니다. 기존 파일과 적용 범위를 먼저 확인하고 새 세션에서 시험하세요.',
      url: 'https://learn.chatgpt.com/docs/agent-configuration/agents-md',
      skill: '$skill-creator에 아래 요청을 전달하세요. 교정 ZIP을 직접 쓴다면 proofread 폴더를 프로젝트의 .agents/skills/에 두고 새 세션에서 $proofread를 호출해 시험하세요. 기존 스킬은 덮어쓰지 마세요.',
      skillUrl: 'https://learn.chatgpt.com/docs/build-skills'
    }
  };
  const work = {
    writing: {name:'글쓰기와 문장 교정', rule:'글을 고칠 때 원문의 의도·말투·사실·수치를 보존해 주세요.', test:'다음 글의 뜻과 말투를 유지하며 자연스럽게 고쳐줘: “이번 모임에 참여가 가능하신 분들은 저에게 알려주시면 감사하겠습니다.”'},
    research: {name:'자료 조사와 비교', rule:'자료를 비교할 때 제 목적에 맞는 추천과 근거, 판단이 달라질 조건을 알려 주세요.', test:'메모를 한 파일에 모으는 방법과 주제별로 나누는 방법을 비교하고, 초보자에게 추천해줘.'},
    coding: {name:'코드 작성과 검토', rule:'코드를 바꾸기 전에 기존 구현을 읽고, 변경한 동작을 적절한 방법으로 확인해 주세요.', test:'현재 프로젝트에서 고치기 전에 확인할 파일과 작은 검증 방법을 설명해줘. 아직 파일은 수정하지 마.'},
    custom: {name:'반복하는 작업', rule:'제 목적과 제약에 맞춰 결과를 만들고 필요한 조건만 질문해 주세요.', test:'제가 자주 하는 일에서 작은 예시 하나를 정하고, 방금 저장한 지침에 맞춰 도와줘.'}
  };
  function status(message, error=false) { $('guide-status').textContent=message; $('guide-status').style.color=error?'#b91c1c':'#166534'; }
  window.guideCopy = async (text, button) => {
    if (!text.trim()) { status('복사할 내용을 먼저 입력해 주세요.',true); return; }
    try {
      await navigator.clipboard.writeText(text);
      const old=button.textContent;button.textContent='복사 완료';
      setTimeout(()=>{button.textContent=old;},1400);
      status('복사했습니다. 위에서 안내한 설정이나 대화에 붙여 넣으세요.');
    } catch {
      status('클립보드 접근이 막혔습니다. 문구를 선택해 직접 복사하거나 TXT로 받아주세요.',true);
      if(button.id==='guide-skill-copy') {$('guide-skill-prompt').focus();$('guide-skill-prompt').select();}
      else if(button.id==='guide-copy') {$('guide-output').focus();$('guide-output').select();}
      else {button.textContent='복사 실패 · 직접 선택';button.setAttribute('aria-label','복사 실패. 표시된 문구를 직접 선택해 복사하세요.');}
    }
  };
  function count(){const t=$('guide-output').value;$('guide-count').textContent=`${t.split('\n').filter(x=>x.trim()).length}줄 · ${t.length}자`;}
  function route(){
    const r=routes[$('guide-environment').value];
    // Only trusted static route strings use HTML; user input stays in textarea.value.
    $('guide-route').innerHTML=`<strong>${r.title}</strong><p>${r.detail}</p><a class="guide-link" href="${r.url}" target="_blank" rel="noopener">공식 설정 안내 열기</a>`;
    $('guide-skill-route').innerHTML=`<p>${r.skill}</p><a class="guide-link" href="${r.skillUrl}" target="_blank" rel="noopener">이 환경의 스킬 안내 열기</a>`;
    // Switching environments must preserve the edited instruction draft.
  }
  function generate(){
    const selected=$('guide-work').value;const w=work[selected];
    const name=selected==='custom'?$('guide-custom').value.trim():w.name;
    if(!name){status('자주 하는 일을 적어주세요.',true);$('guide-custom').focus();return;}
    const lengths={adaptive:'질문의 복잡도에 맞춰 설명하고, 답과 핵심 이유부터 알려 주세요.',short:'핵심부터 짧게 답하되 중요한 조건과 한계는 생략하지 마세요.',reason:'답부터 말하고, 이해에 필요한 이유와 구체적인 예시를 덧붙여 주세요.'};
    const lines=['한국어로 쉽게 답해 주세요.',lengths[$('guide-length').value],`주로 ${name}에 도움을 받고 싶습니다.`,w.rule,'확인한 사실과 추정을 구분하고, 중요한 주장에는 근거를 연결해 주세요.','실제로 한 일과 아직 확인하지 못한 일을 구분해 주세요.'];
    if($('guide-md').checked)lines.push('긴 내용은 가능하면 기존 Markdown(.md) 문서에 담고, 채팅에는 핵심 요약과 파일 링크를 주세요. 파일 생성이 안 되면 저장했다고 하지 말고 복사할 Markdown을 주세요.');
    $('guide-output').value=lines.join('\n');count();
    $('guide-skill-prompt').value=`제가 반복하는 “${name}” 작업을 위한 스킬을 만들어 주세요. 현재 환경의 지원 방식과 기존 스킬을 먼저 확인해 주세요. 언제 쓰는지, 필요한 입력, 작업 순서, 결과와 확인 방법을 정리하세요. ${w.rule} 공통 지침은 짧게 유지하고 상세 절차는 이 작업에서만 읽게 해주세요. 실제 저장 위치와 시험 결과를 알려 주세요. 설치 기능이 없으면 다시 쓸 요청문으로 제공하세요.`;
    $('guide-test').textContent=w.test;
    status('지침을 만들었습니다. 문구를 읽고 필요한 부분만 고쳐 복사하세요.');
  }
  $('guide-work').addEventListener('change',()=>{$('guide-custom-wrap').hidden=$('guide-work').value!=='custom';status('조건을 바꿨습니다. 아래 만들기 버튼을 누르면 편집한 문구가 새로 작성됩니다.');});
  ['guide-length','guide-md'].forEach(id=>$(id).addEventListener('change',()=>status('조건을 바꿨습니다. 만들기 버튼을 누르면 문구에 반영됩니다.')));
  $('guide-environment').addEventListener('change',route);
  $('guide-generate').addEventListener('click',generate);
  $('guide-output').addEventListener('input',count);
  $('guide-copy').addEventListener('click',e=>window.guideCopy($('guide-output').value,e.currentTarget));
  $('guide-skill-copy').addEventListener('click',e=>window.guideCopy($('guide-skill-prompt').value,e.currentTarget));
  $('guide-download').addEventListener('click',()=>{
    if(!$('guide-output').value.trim()){status('받을 내용을 먼저 입력해 주세요.',true);return;}
    const url=URL.createObjectURL(new Blob([$ ('guide-output').value],{type:'text/plain;charset=utf-8'}));
    const a=document.createElement('a');a.href=url;a.download='my-ai-instructions.txt';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);status('TXT 파일 다운로드를 시작했습니다.');
  });
  route();generate();
})();
