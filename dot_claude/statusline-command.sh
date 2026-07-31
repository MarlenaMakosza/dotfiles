#!/bin/bash
# Claude Code Status Line - posh-git style, multiline, with orange clawd animation
# Reads JSON from stdin.
node -e "
const chunks=[];
process.stdin.on('data',chunk=>chunks.push(chunk));
process.stdin.on('end',()=>{
  try {
    const data=JSON.parse(chunks.join(''));
    const cwd=data.cwd||'.';
    const dirName=(data.cwd||'').replace(/.*[\\/\\\\]/,'');
    const exec=require('child_process').execSync;
    const gitOpts={cwd,stdio:['pipe','pipe','pipe']};

    // ANSI color codes
    const RESET='\\x1b[0m';
    const BOLD='\\x1b[1m';
    const CYAN='\\x1b[36m';
    const GREEN='\\x1b[32m';
    const RED='\\x1b[31m';
    const YELLOW='\\x1b[33m';
    const MAGENTA='\\x1b[35m';
    const DIM='\\x1b[2m';
    const ORANGE='\\x1b[38;5;208m';
    const ORANGE_DIM='\\x1b[38;5;166m';

    // ---------- Line 1: dir / git / model / context / cost ----------
    let gitStatus='';
    try {
      const branch=exec('git rev-parse --abbrev-ref HEAD',gitOpts).toString().trim();

      let syncLabel='';
      try {
        const commitsAhead=parseInt(exec('git rev-list @{u}..HEAD --count',gitOpts).toString().trim())||0;
        const commitsBehind=parseInt(exec('git rev-list HEAD..@{u} --count',gitOpts).toString().trim())||0;
        if(commitsAhead===0&&commitsBehind===0) syncLabel=CYAN+'='+RESET;
        else if(commitsAhead>0&&commitsBehind===0) syncLabel=CYAN+'ahead '+commitsAhead+RESET;
        else if(commitsAhead===0&&commitsBehind>0) syncLabel=CYAN+'behind '+commitsBehind+RESET;
        else syncLabel=CYAN+'ahead '+commitsAhead+' behind '+commitsBehind+RESET;
      } catch(e){ syncLabel=''; }

      const porcelain=exec('git status --porcelain',gitOpts).toString();
      let stagedAdded=0,stagedModified=0,stagedDeleted=0;
      let worktreeAdded=0,worktreeModified=0,worktreeDeleted=0;
      let hasUntracked=false;
      porcelain.split('\\n').filter(Boolean).forEach(line=>{
        const indexCol=line[0], worktreeCol=line[1];
        if(indexCol==='A') stagedAdded++;
        else if(indexCol==='M'||indexCol==='R'||indexCol==='C') stagedModified++;
        else if(indexCol==='D') stagedDeleted++;
        if(worktreeCol==='?') hasUntracked=true;
        else if(worktreeCol==='M') worktreeModified++;
        else if(worktreeCol==='D') worktreeDeleted++;
        if(indexCol==='?'&&worktreeCol==='?') { hasUntracked=true; }
      });

      const syncPart=syncLabel?' '+syncLabel:'';
      const stagedStr=GREEN+'+'+stagedAdded+' ~'+stagedModified+' -'+stagedDeleted+RESET;
      const worktreeStr=RED+'+'+worktreeAdded+' ~'+worktreeModified+' -'+worktreeDeleted+RESET;
      const untrackedStr=hasUntracked?RED+' !'+RESET:'';
      gitStatus=' '+DIM+'['+RESET+YELLOW+BOLD+branch+RESET+syncPart+' '+DIM+'|'+RESET+' '+stagedStr+' '+DIM+'|'+RESET+' '+worktreeStr+untrackedStr+DIM+']'+RESET;
    } catch(e){}

    const modelName=data.model?.display_name||'';
    const contextPct=data.context_window?.used_percentage;
    const contextColor=contextPct>75?RED:contextPct>50?YELLOW:'';
    const contextStr=contextPct!=null?' '+DIM+'|'+RESET+' '+contextColor+'Ctx: '+Math.round(contextPct)+'%'+RESET:'';
    const totalCost=data.cost?.total_cost_usd;
    const costStr=totalCost!=null?' '+DIM+'|'+RESET+' '+GREEN+'\$'+totalCost.toFixed(2)+RESET:'';
    const line1=dirName+gitStatus+' '+DIM+'|'+RESET+' '+MAGENTA+modelName+RESET+contextStr+costStr;

    // ---------- Line 2: tokens / processes / time / changes ----------
    const inTok=data.context_window?.total_input_tokens||0;
    const outTok=data.context_window?.total_output_tokens||0;
    const totalTok=inTok+outTok;
    const fmtTok=n=>n>=1000?(n/1000).toFixed(1)+'k':String(n);
    const tokenStr=CYAN+'🪙 '+fmtTok(totalTok)+RESET;

    let claudeCount=0, mcpCount=0;
    try {
      const claudePidsRaw=exec('pgrep -x claude',{stdio:['pipe','pipe','ignore']}).toString().trim();
      const claudePids=claudePidsRaw?claudePidsRaw.split('\\n'):[];
      claudeCount=claudePids.length;
      if(claudeCount>0){
        const psAll=exec('ps -eo pid,ppid,comm',{stdio:['pipe','pipe','ignore']}).toString();
        const rows=psAll.split('\\n').slice(1).map(l=>l.trim().split(/\\s+/));
        mcpCount=rows.filter(r=>claudePids.includes(r[1])&&r[2]!=='claude').length;
      }
    } catch(e){ claudeCount=0; mcpCount=0; }
    const procStr=YELLOW+'cc:'+claudeCount+RESET+' '+DIM+'/'+RESET+' '+MAGENTA+'mcp:'+mcpCount+RESET;

    const durationMs=data.cost?.total_duration_ms||0;
    const durationSec=Math.floor(durationMs/1000);
    const hh=Math.floor(durationSec/3600);
    const mm=Math.floor((durationSec%3600)/60);
    const ss=durationSec%60;
    const timeFmt=hh>0?hh+':'+String(mm).padStart(2,'0')+':'+String(ss).padStart(2,'0'):mm+':'+String(ss).padStart(2,'0');
    const timeStr=CYAN+'⏱ '+timeFmt+RESET;

    const linesAdded=data.cost?.total_lines_added||0;
    const linesRemoved=data.cost?.total_lines_removed||0;
    const changesStr=GREEN+'+'+linesAdded+RESET+' '+RED+'-'+linesRemoved+RESET;

    const line2=tokenStr+' '+DIM+'|'+RESET+' '+procStr+' '+DIM+'|'+RESET+' '+timeStr+' '+DIM+'|'+RESET+' '+changesStr;

    // ---------- Lines 3-5: clawd, ambling left-right in orange ----------
    const crabFrame=[
      ' .=\"=. ',
      '(;o o;)',
      '(_,+,_)',
    ];
    const laneWidth=24;
    const crabWidth=crabFrame[0].length;
    const maxOffset=laneWidth-crabWidth;
    const t=Math.floor(durationMs/500);
    const cyclePos=t%(maxOffset*2||1);
    const offset=cyclePos<=maxOffset?cyclePos:maxOffset*2-cyclePos;
    const pad=' '.repeat(Math.max(0,offset));
    const crabColor=(Math.floor(t/(maxOffset||1))%2===0)?ORANGE:ORANGE_DIM;
    const crabLines=crabFrame.map(row=>crabColor+pad+row+RESET);

    process.stdout.write([line1,line2,...crabLines].join('\\n'));
  } catch(e) {
    process.stdout.write('statusline error: '+e.message);
  }
});
"
