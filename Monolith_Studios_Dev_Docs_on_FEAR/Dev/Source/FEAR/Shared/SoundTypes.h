// ----------------------------------------------------------------------- //
//
// MODULE  : SoundTypes.h
//
// PURPOSE : Sound types
//
// CREATED : 11/12/97
//
// ----------------------------------------------------------------------- //

#ifndef __SOUND_TYPES_H__
#define __SOUND_TYPES_H__

enum SoundPriority
{
	SOUNDPRIORITY_INVALID		= -1,

	SOUNDPRIORITYBASE_MISC		= 0,
	SOUNDPRIORITYBASE_AI		= 2,
	SOUNDPRIORITYBASE_PLAYER	= 4,

	SOUNDPRIORITYMOD_LOW		= 0,
	SOUNDPRIORITYMOD_MEDIUM		= 1,
	SOUNDPRIORITYMOD_HIGH		= 2,

    SOUNDPRIORITY_MISC_LOW		= SOUNDPRIORITYBASE_MISC + SOUNDPRIORITYMOD_LOW,
	SOUNDPRIORITY_MISC_MEDIUM	= SOUNDPRIORITYBASE_MISC + SOUNDPRIORITYMOD_MEDIUM,
	SOUNDPRIORITY_MISC_HIGH		= SOUNDPRIORITYBASE_MISC + SOUNDPRIORITYMOD_HIGH,
	SOUNDPRIORITY_AI_LOW		= SOUNDPRIORITYBASE_AI + SOUNDPRIORITYMOD_LOW,
	SOUNDPRIORITY_AI_MEDIUM		= SOUNDPRIORITYBASE_AI + SOUNDPRIORITYMOD_MEDIUM,
	SOUNDPRIORITY_AI_HIGH		= SOUNDPRIORITYBASE_AI + SOUNDPRIORITYMOD_HIGH,
	SOUNDPRIORITY_PLAYER_LOW	= SOUNDPRIORITYBASE_PLAYER + SOUNDPRIORITYMOD_LOW,
	SOUNDPRIORITY_PLAYER_MEDIUM = SOUNDPRIORITYBASE_PLAYER + SOUNDPRIORITYMOD_MEDIUM,
	SOUNDPRIORITY_PLAYER_HIGH	= SOUNDPRIORITYBASE_PLAYER + SOUNDPRIORITYMOD_HIGH
};

// Sound class flags
enum SoundClass
{
	DEFAULT_SOUND_CLASS = 0,
	WEAPONS_SOUND_CLASS,
	SPEECH_SOUND_CLASS,
	NUM_SOUND_CLASSES
};



#endif // __SOUND_TYPES_H__
