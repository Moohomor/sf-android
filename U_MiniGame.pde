void choose_minigame(String[] tokens) {
  String name=tokens[1];
  //println(name,name.equals("agility"));
  if (name.equals("quick_tap"))
    state=new InternalMG(int(tokens[2]));
  else if (name.equals("agility"))
    state=new AgilityMG(int(tokens[2]));
}
class Minigame extends State {
  void upd() {}
}
class AgilityMG extends Minigame {
  int trg,spos,sz,pos=0,count=1,rep,
  perf=0,good=0,norm=0,loss=0;
  long born=millis();
  AgilityMG(int r) {
    rep=r;
    init();
  }
  void init() {
    spos=int(random(100,height/2-400));
    trg=int(random(pos+380,height-200));
    sz=int(random(200,800));
  }
  void upd() {
    noStroke();
    fill(0,170);
    rect(width/2-50,90,100,height-180,15);
    fill(#FFFF63);
    rect(width/2-45,trg-sz/2,90,sz,15);
    fill(#80FF63);
    rect(width/2-45,trg-sz/4,90,sz/2,15);
    fill(#63BDFF);
    rect(width/2-45,trg-sz/8,90,sz/4,15);
    fill(255);
    rect(width/2-40,pos-30,80,60,15);
    pos=int(spos+(height-200)*(millis()-born)/1600);
  }
  void mPressed() {
    count+=1;
    int d=abs(pos-trg);
    if (d<sz/8)      perf++;
    else if (d<sz/4) good++;
    else if (d<sz/2) norm++;
    else             loss++;
    init();
    if (count>rep) {
      state=new Main();
      engine.module.pos++;
      nvars.put("agility.score",perf+good+norm+.0);
    }
    println("Score:",perf,good,norm,loss);
  }
}
class InternalMG extends Minigame {
  long end,born,tap;int ww,hh,score=0,endscr;
  byte state_=0;
  InternalMG(int es) {
    born=millis();
    end=millis()+int(random(500,4400));
    ww=width/2;
    hh=height/2;
    endscr=es;
  }
  void upd() {println(state);
    switch (state_) {
    case 0:
      tap=millis();
      if (millis()<end) {
        background(240,10,10);
        fill(255);
        textSize(60);
        textAlign(CENTER);
        text("When the screen will become green, tap as quick as it possible",0,height-400,width,height);
      } else {
        background(10,230,10);
        stroke(255);
        strokeWeight(50);
        line(ww-250,hh+300,ww+250+max(-1000,end-millis())/2,hh+300);
      }
    break;
    case 1:
      stroke(255);
      background(20,220,20);
      strokeWeight(50);
      noFill();
      //line(ww-200,hh,ww,hh+200);
      //line(ww,hh+200,ww+200,hh-300);
      ellipse(ww,hh,600,600);
      noStroke();
      fill(245,245,245);
      textSize(160);
      textAlign(CENTER, CENTER);
      text(str(score),ww,hh);
      break;
    case 2:
      stroke(255);
      background(220,20,20);
      strokeWeight(50);
      line(ww-200,hh-200,ww+200,hh+200);
      line(ww+200,hh-200,ww-200,hh+200);
      noStroke();
    }
    if (state_>0) {
      if (millis()-tap>1000) {
        end=millis()+int(random(500,5000));
        state_=0;
      }
      else if (score>=endscr||millis()-born>40000) {
        state=new Main();
        engine.module.pos++;
        nvars.put("quick_tap.score",score+0.0);
      }
    }
    super.upd();
  }
  void mPressed() {
    if (state_==0) {
      if (millis()<end) state_=2;
      else {
        state_=1;
        score+=1000/(millis()-end);
      }
    }
  }
}