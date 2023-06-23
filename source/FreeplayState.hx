package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var AllPossibleSongs:Array<String> = ['main', 'davo', 'extras', 'old', 'joke', 'purgatory', 'covers
	private var Catagories:Array<String> = ['dave', 'joke', 'extras', 'dave2.5', 'classic', 'cover', 'fanmade', 'finale'];

	private var CurrentPack:Int = 0;

	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [
        0xFF00FF00, // DAVO
        0xFFAFD700, // DAVO MAD
        0xFFFF5800, // BIGBI
        0xFFFF0000, // EXPUNGED BIGBI
        0xFFFF8500, // EXPUNGED DAVO AND EXPUNGED BIGBI
        0xFFFFFFFF, // SEAL
        0xFFAF3700, // JADE
	0xFFAF7C64, // JADE FAN
	0xFF493415, // SOOKIE
        0xFF000000, //UNFAIR BAMBI
        0xFF505050, //SCARY
        0xFF000000, //YOUR MOM
        0xFFE00000, //BAMBITCH
        0xFF43E000, //BANDU PLAY STORE
        0xFF0021E0, //DEEZI
        0xFFFFF33B, //ORIGIN
        0xFF0021E0, //DAL
        0xFFA0E000, //THE DUO 1
        0xFF43E000, //UNRECOVERED SAVE
        0xFFE07000, //CAVO
        0xFF707070, //BOXI
        0xFFE0BE00, //JUSTIN
        0xFFE0BE00, //JASONBOM
        0xFFAF3700 //THE DUO 2
    ];

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */
		#if desktop
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end
		
		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		add(bg);

		CurrentSongIcon = new FlxSprite(0,0).loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));

		CurrentSongIcon.centerOffsets(false);
		CurrentSongIcon.x = (FlxG.width / 2) - 256;
		CurrentSongIcon.y = (FlxG.height / 2) - 256;
		CurrentSongIcon.antialiasing = true;

		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.x = (FlxG.width / 2) - 162;
		Highscore.load();
		add(NameAlpha);

		add(CurrentSongIcon);

		super.create();
	}

	public function LoadProperPack()
	{
		switch (Catagories[CurrentPack].toLowerCase())
		{
				case 'main':
					addWeek(['Gravo', 'Anticontrol'], 0, ['davo', 'davo']);
				        addWeek(['Outrage'], 1, ['DavoCrazy']);
					addWeek(['Watching Over', 'Dark Matters'], 2, ['bigbi', 'bigbi']);
					addWeek(['Discremia'], 3, ['expungedbigbi']);
					addWeek(['Ijolonian'], 4, ['dude']);
					addWeek(['GLitched'], 5, ['expungeddavo']);
					addWeek(['squish', 'uncute'], 6, ['seal', 'sealmad']);
					addWeek(['Cute Cat', 'Final Cuteness', 'Meow'], 7, ['jade', 'jade', 'jade']);
					addWeek(['Jade Fan'], 8, ['jadefan']);
					addWeek(['Addiction'], 6, ['d']);
				        addWeek(['Refaction'], 9, ['sookie']);
					addWeek(['Ddosing'], 10, ['unfair_bambi']);
					addWeek(['Colloskipepapkophobia'], 11, ['scary']);
					addWeek(['REAL THEARCHY'], 6, ['no']);
					addWeek(['Impossibleness'], 11, ['yourmom']);
					addWeek(['Cursebreaker'], 6, ['pandi']);
					addWeek(['Jeffsanity'], 11, ['jeff']);
					addWeek(['Artifact'], 11, ['jeff']);
					addWeek(['Fuck You'], 12, ['bambitch']);
                                        addWeek(['Frickyouphobia'], 12, ['hell']);
					addWeek(['Phonology'], 6, ['truehell']);
					addWeek(['Death Finale'], 12, ['finalexpunged']);
				case 'davo':
					addWeek(['Intensity', 'ChallengeDavo', 'Pixelated'], 0, ['DavoCrazy', 'DDavo', 'pix']);
				case 'extras':
					addWeek(['Spiralation'], 9, ['spibi']);
					addWeek(['Playstore'], 13, ['banduplaystore']);
                                        addWeek(['Deathness'], 14, ['deezi']);
					addWeek(['Trueform'], 15, ['origin']);
					addWeek(['Naive Dumbass'], 6, ['dumbassunga']);
					addWeek(['Fren Dumbass'], 6, ['dumbassave']);
					addWeek(['Limbless'], 16, ['dal']);
					addWeek(['Reference'], 17, ['duo']);
					addWeek(['Shut Up!'], 12, ['rednessi']);
					addWeek(['Unsaved'], 18, ['unrecovered_save']);
					addWeek(['Sense Of Humor'], 12, ['dumbo']);
					addWeek(['Smallest'], 16, ['smoli']);
					addWeek(['Retrieved'], 10, ['bavbi']);
					addWeek(['Underwater'], 16, ['axobi']);
					addWeek(['Road Rage'], 13, ['carbi']);
					addWeek(['Bouncy Balls'], 13, ['candi']);
					addWeek(['Sacrafice'], 18, ['bam']);
					addWeek(['Queeve'], 12, ['quabam']);
					addWeek(['Thefurry'], 6, ['TearchyBuddy']);
					addWeek(['Glossed'], 12, ['beebi']);
					addWeek(['Friendship'], 19, ['cavo']);
					addWeek(['Deception'], 10, ['banxu']);
				case 'old':
					addWeek(['Old Gravo'], 0,  ['davo']);
				        addWeek(['Old Spiralation'], 6, ['oldspibi']);
				        addWeek(['Old Ddosing'], 10, ['unfair_bambi']);
				case 'joke':
					addWeek(['Fangirl'], 13, ['fangirl']);
					addWeek(['Unreal Box'], 20, ['boxi']);
					addWeek(['Bambi Is Dead'], 13, ['bambi']);
					addWeek(['Meme God'], 12, ['carl']);
					addWeek(['Vs Pandi Easter'], 6, ['pandi']);
					addWeek(['Justin Deez Nuts'], 21, ['justin']);
				case 'purgatory':
					addWeek(['Go Down For Candy'], 6, ['none']);
				case 'covers':
					addWeek(['Strawberry'], 13, ['disruption']);
					addWeek(['Thunderstorm'], 7, ['thunder']);
					addWeek(['Go Jade Go!'], 7, ['jade']);
					addWeek(['Onslaught'], 2, ['bigbi']);
					addWeek(['Devcore'], 6, ['seal']);
					addWeek(['Zanta'], 2, ['bigbi']);
					addWeek(['De Trouble'], 10, ['unfair_bambi']);
					addWeek(['confronting-yourself'], 22, ['jasonbom']);
					addWeek(['Final Meows'], 23, ['duo3']);
					addWeek(['Ferocious'], 0, ['davo']);

		}
	}

	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
		{
			CurrentPack = AllPossibleSongs.length - 1;
		}
		if (CurrentPack == AllPossibleSongs.length)
		{
			CurrentPack = 0;
		}
		NameAlpha.destroy();
		NameAlpha = new Alphabet(40,(FlxG.height / 2) - 282,AllPossibleSongs[CurrentPack],true,false);
		NameAlpha.x = (FlxG.width / 2) - 164;
		add(NameAlpha);
		CurrentSongIcon.loadGraphic(Paths.image('week_icons_' + (AllPossibleSongs[CurrentPack].toLowerCase())));
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		super.update(elapsed);


		if (!InMainFreeplayState) 
		{
			if (controls.LEFT_P)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack)
			{
				loadingPack = true;
				LoadProperPack();
				FlxTween.tween(CurrentSongIcon, {alpha: 0}, 0.3);
				FlxTween.tween(NameAlpha, {alpha: 0}, 0.3);
				new FlxTimer().start(0.5, function(Dumbshit:FlxTimer)
				{
					CurrentSongIcon.visible = false;
					NameAlpha.visible = false;
					GoToActualFreeplay();
					InMainFreeplayState = true;
					loadingPack = false;
				});
			}
			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}	
		
			return;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);


		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (FlxG.keys.pressed.SHIFT){
				LoadingState.loadAndSwitchState(new ChartingState());
			}else{
				LoadingState.loadAndSwitchState(new PlayState());
			}

			FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
