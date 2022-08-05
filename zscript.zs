version "4.4.2"

/**
 * This file is an entry point for Autoautosave.
 */
#include "zscript/aas_main.zs"

/**
 * These files are the heart of Autoautosave. They define and generate events.
 */
#include "zscript/aas_event_source.zs"
#include "zscript/aas_event.zs"
#include "zscript/aas_save_timer.zs"
#include "zscript/aas_token.zs"
#include "zscript/checkers/aas_active_enemies_checker.zs"

/**
 * This file contains examples of Universal Autoautosave Tokens.
 */
#include "zscript/aas_universal_token_examples.zs"

/**
 * These classes handle events, each in its own way.
 */
#include "zscript/handlers/aas_event_handler.zs"
#include "zscript/handlers/aas_event_handlers.zs"
#include "zscript/handlers/aas_logger.zs"
#include "zscript/handlers/aas_saver.zs"
#include "zscript/handlers/aas_screenshot_maker.zs"
#include "zscript/handlers/aas_voice.zs"

/**
 * These classes count the enemies on the level.
 */
#include "zscript/counters/aas_enemies_counter.zs"
#include "zscript/counters/aas_active_enemies_counter.zs"
#include "zscript/counters/aas_active_bosses_counter.zs"

/**
 * These classes call engine's save and screenshot functions.
 */
#include "zscript/aas_game_actions.zs"
#include "zscript/aas_game_action_scheduler.zs"

/**
 * These classes provide access to time.
 */
#include "zscript/clocks/aas_clock.zs"
#include "zscript/clocks/aas_level_clock.zs"

/**
 * These classes are helper utilities.
 */
#include "zscript/aas_timestamp.zs"
#include "zscript/aas_log.zs"
#include "zscript/aas_cvar.zs"
#include "zscript/aas_precache_sounds.zs"
#include "zscript/aas_precache_other_sounds_too.zs"
#include "zscript/aas_function.zs"

/**
 * Tests.
 *
 * Not much here, sadly.
 */
#include "zscript/tests/aas_active_enemies_checker_test.zs"
