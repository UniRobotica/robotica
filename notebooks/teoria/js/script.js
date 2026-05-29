function showTab(id,button){

    const sections =
        document.querySelectorAll(".section");

    sections.forEach(sec=>{
        sec.classList.remove("active");
    });

    document
        .getElementById(id)
        .classList.add("active");

    const buttons =
        document.querySelectorAll(".tab-button");

    buttons.forEach(btn=>{
        btn.classList.remove("active");
    });

    button.classList.add("active");

}

function drawLeg(){

    const canvas =
        document.getElementById("legCanvas");

    const ctx =
        canvas.getContext("2d");

    ctx.clearRect(0,0,canvas.width,canvas.height);

    const th1 =
        parseFloat(
            document.getElementById("th1").value
        );

    const th2 =
        parseFloat(
            document.getElementById("th2").value
        );

    const t1 = th1*Math.PI/180;
    const t2 = th2*Math.PI/180;

    const L = 120;

    const cx = 250;
    const cy = 250;

    const x1 =
        cx + L*Math.cos(t1);

    const y1 =
        cy - L*Math.sin(t1);

    const x2 =
        x1 + L*Math.cos(t1+t2);

    const y2 =
        y1 - L*Math.sin(t1+t2);

    ctx.strokeStyle="#1565c0";
    ctx.lineWidth=8;

    ctx.beginPath();

    ctx.moveTo(cx,cy);
    ctx.lineTo(x1,y1);
    ctx.lineTo(x2,y2);

    ctx.stroke();

    ctx.fillStyle="#1565c0";

    ctx.beginPath();
    ctx.arc(cx,cy,8,0,2*Math.PI);
    ctx.fill();

    ctx.beginPath();
    ctx.arc(x1,y1,8,0,2*MathPI);
    ctx.fill();

    ctx.beginPath();
    ctx.arc(x2,y2,10,0,2*Math.PI);
    ctx.fill();

    document.getElementById("theta1Text")
    .innerHTML =
    "θ1 = " + th1.toFixed(1) + "°";

    document.getElementById("theta2Text")
    .innerHTML =
    "θ2 = " + th2.toFixed(1) + "°";

    document.getElementById("xText")
    .innerHTML =
    "x = " + ((x2-cx)/20).toFixed(2);

    document.getElementById("yText")
    .innerHTML =
    "y = " + ((cy-y2)/20).toFixed(2);

}

function drawWave(){

    const canvas =
        document.getElementById("waveCanvas");

    const ctx =
        canvas.getContext("2d");

    ctx.clearRect(0,0,canvas.width,canvas.height);

    const A =
        parseFloat(
            document.getElementById("amp").value
        );

    const w =
        parseFloat(
            document.getElementById("freq").value
        );

    const p =
        parseFloat(
            document.getElementById("phase").value
        );

    ctx.beginPath();

    for(let x=0;x<600;x++){

        const t=x/60;

        const y=
            150 -
            A*Math.sin(
                w*t + p*Math.PI/180
            );

        if(x===0){

            ctx.moveTo(x,y);

        }else{

            ctx.lineTo(x,y);

        }

    }

    ctx.strokeStyle="#1565c0";
    ctx.lineWidth=3;
    ctx.stroke();

}

document
.getElementById("th1")
.addEventListener("input",drawLeg);

document
.getElementById("th2")
.addEventListener("input",drawLeg);

document
.getElementById("amp")
.addEventListener("input",drawWave);

document
.getElementById("freq")
.addEventListener("input",drawWave);

document
.getElementById("phase")
.addEventListener("input",drawWave);

drawLeg();
drawWave();