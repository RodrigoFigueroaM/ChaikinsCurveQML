import QtQuick 2.4

Canvas {
    id: canvas
    width: 400
    height: 400

    property var spline

    //    Rectangle {
    //        color: "#000"
    //        anchors.fill: parent
    //    }
    contextType: qsTr("2d")
    property bool showConvexHull: true
    property bool showSpline: false
    property var drawPoints: (function (points, length, color, linewidth) {
        var ctx = getContext('2d')
        ctx.strokeStyle = color
        ctx.lineWidth = linewidth
        ctx.beginPath()
        for (var i = 0; i < length - 1; i++) {
            ctx.moveTo(points[i].x, points[i].y)
            ctx.lineTo(points[i + 1].x, points[i + 1].y)
        }
        ctx.stroke()
    })
    property var drawConvexHull: (function () {
        for (var i = 0; i < controller.splines().length; i++) {
            var spline = controller.splines()[i]
            canvas.drawPoints(spline.controlPoints(),
                              spline.controlPoints().length,
                              Qt.rgba(0.7, 0.3, 0.7, 1.0), 2)
        }
        canvas.requestPaint()
    })
    property var drawSpline: (function () {
        for (var i = 0; i < controller.splines().length; i++) {
            var spline = controller.splines()[i]

            if (spline.controlPoints().length > 1) {
                spline.compute()
            }
            canvas.drawPoints(spline.points(), spline.points().length,
                              Qt.rgba(0.2, 0.3, 1.0, 1.0), 2)
        }
        canvas.requestPaint()
    })
    property var clear: (function () {
        var ctx = getContext('2d')
        ctx.fillStyle = Qt.rgba(0.2, 0.2, 0.2, 1)
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        ctx.fillRect(0, 0, width, height)
    })
    onPaint: {
        var ctx = getContext('2d')
        canvas.clear()
        if (showConvexHull)
            drawConvexHull()
        if (showSpline)
            drawSpline()
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property real pointX
        property real pointY
        property real lastX
        property real lastY
        onReleased: {
            spline = controller.getLast()
            spline.addControlPoint(Qt.vector3d(mouseX, mouseY, 0))
            canvas.requestPaint()
            print(spline)
        }
    }
}
