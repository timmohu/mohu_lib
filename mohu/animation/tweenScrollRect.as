package mohu.animation {	import flash.display.DisplayObject;	import flash.geom.Rectangle;	public function tweenScrollRect(target:DisplayObject, rectangle:Rectangle, frames:int, easing:Function = null, onComplete:Function = null, onEnterFrame:Function = null, roundValues:Boolean = true):ScrollRectTween {		var scrollRectTween:ScrollRectTween = new ScrollRectTween(target, rectangle, frames, easing, roundValues);		if (onComplete != null) scrollRectTween.onComplete.addListener(onComplete);		if (onEnterFrame != null) scrollRectTween.onEnterFrame.addListener(onEnterFrame);		Animator.add(scrollRectTween);		return scrollRectTween;	}}