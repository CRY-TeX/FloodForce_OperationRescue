extends Node2D

onready var Rain = $Rain
onready var AnjelicChoirPlayer = $AnjelicChoirPlayer
onready var PianoThemePlayer = $PianoThemePlayer
onready var GameOverPlayer = $GameOverPlayer

func play_rain():
    Rain.play()

func stop_rain():
    Rain.stop()

func play_reach_hospital():
    AnjelicChoirPlayer.play()

func stop_reach_hospital():
    AnjelicChoirPlayer.stop()

func play_piano_theme():
    PianoThemePlayer.play()

func stop_piano_theme():
    PianoThemePlayer.stop()

func play_game_over():
    GameOverPlayer.play()

func stop_game_over():
    GameOverPlayer.stop()
