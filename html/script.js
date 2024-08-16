let screenWidth = window.innerWidth;
let screenHeight = window.innerHeight;

        window.addEventListener('message', (event)=>{
            let datas = event.data

            if (datas.state === 'waypointActive'){
                document.querySelector('.waypoint').classList.add('animate__fadeIn')
                document.querySelector('.waypoint').classList.remove('animate__fadeOut')
                document.querySelector('.waypoint').style.display = 'flex'

                let waypoint = document.querySelector('.waypoint')
                let top = Math.trunc(screenHeight*datas.pos.y)
                let left = Math.trunc(screenWidth*datas.pos.x)
                waypoint.style.top = `${top}px`
                waypoint.style.left = `${left}px`
                waypoint.style.transform = `scale(${datas.scale})`
                
                document.querySelector('.distance').innerHTML = getDistance(datas.distance)

                if (datas.onScreen){
                    document.querySelector('.waypointmiddle').style.display = 'flex'
                    document.querySelector('.distance').style.display = 'flex'
                    document.querySelector('.waypointarr').style.display = 'none'
                }
                else{

                    document.querySelector('.waypointmiddle').style.display = 'none'
                    document.querySelector('.distance').style.display = 'none'
                    document.querySelector('.waypointarr').style.display = 'flex'
                    document.querySelector('.waypoint').style.transform = `rotate(${getRotation(top, left)}deg)`;
                }
            }

            if (datas.state === 'waypointDeactive'){
                document.querySelector('.waypoint').classList.add('animate__fadeOut')
                document.querySelector('.waypoint').classList.remove('animate__fadeIn')

                setTimeout(()=>{
                    document.querySelector('.waypoint').style.display = 'none'
                },500)
            }
        })

        function getDistance(dist){
            if (Math.round(dist) >= 1000){
                return `${Math.round((dist/1000)*100)/100}KM`
            }
            else{
                return `${Math.round(dist)}M`
            }
        }

        function getRotation(top, left){
            let distanceToBottom = screenHeight - top;
            let distanceToRight = screenWidth - left;
            let angle = 0.0

            if (top <= distanceToBottom && top <= left && top <= distanceToRight) {
                angle = 0.0;
            } else if (distanceToBottom <= top && distanceToBottom <= left && distanceToBottom <= distanceToRight) {
                angle = 180.0;
            } else if (left <= top && left <= distanceToBottom && left <= distanceToRight) {
                angle = -90.0
            } else {
                angle = 90.0;
            }

            return angle
        }