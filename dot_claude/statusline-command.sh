#!/bin/bash
# Claude Code Status Line - posh-git style with ANSI colors
# Reads JSON from stdin, outputs: dir [branch = +S ~S -S | +W ~W -W !] | model | context % | cost
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

    let gitStatus='';
    try {
      const branch=exec('git rev-parse --abbrev-ref HEAD',gitOpts).toString().trim();

      // upstream sync status
      let syncLabel='';
      try {
        const upstream=exec('git rev-parse --abbrev-ref @{u}',gitOpts).toString().trim();
        const commitsAhead=parseInt(exec('git rev-list @{u}..HEAD --count',gitOpts).toString().trim())||0;
        const commitsBehind=parseInt(exec('git rev-list HEAD..@{u} --count',gitOpts).toString().trim())||0;
        if(commitsAhead===0&&commitsBehind===0) syncLabel=CYAN+'='+RESET;
        else if(commitsAhead>0&&commitsBehind===0) syncLabel=CYAN+'ahead '+commitsAhead+RESET;
        else if(commitsAhead===0&&commitsBehind>0) syncLabel=CYAN+'behind '+commitsBehind+RESET;
        else syncLabel=CYAN+'ahead '+commitsAhead+' behind '+commitsBehind+RESET;
      } catch(e){ syncLabel=''; }

      // parse git status --porcelain
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
    process.stdout.write(dirName+gitStatus+' '+DIM+'|'+RESET+' '+MAGENTA+modelName+RESET+contextStr+costStr);
  } catch(e) {
    process.stdout.write('statusline error: '+e.message);
  }
});
"
