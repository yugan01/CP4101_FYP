import SwiftUI

struct AppConstants {
    //static let accentColor = Color(hexString: "#ED4E27")
    
    static let allExercises: [Exercise] = [
        // Dynamic Warm Up [Basic]
        Exercise(name: "Forward Runs to Side Shuffles", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Backward Runs to V-Shuffles", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "High Knee Cross Touch to Leg Swings (Front & Side)", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Walk & Scoop", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Knee Hugs to Quadriceps Stretch", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Giant Wide Steps to Squat", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Knee Turn In to Reverse Lunge with Side Reach", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Multi-Hip (Modified / Full) to 3-Point Calf Stretch", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Seated Lower Body Stretches", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),

        // Dynamic Warm Up [Move With Me Set A]
        Exercise(name: "Running to Sliding", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Backward Running to Skipping", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Hopping to Galloping", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "High Knee Cross Touch to Heel Walking", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Step Squat to Crawling", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Modified Multi Hip to Jumping", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),

        // Dynamic Warm Up [Move With Me Set B]
        Exercise(name: "Gallop, Hop, Slide, Skip", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Leg Swings (Front & Side)", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "High Knee Marching (Correct Coordination, Forward & Backward Moving)", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Skipping", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),

        // Dynamic Warm Up [Sports Set A]
        Exercise(name: "Forward Runs to Side Shuffles", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Backward Runs to V-Shuffles", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Leg Circles to Low Skips to Side Skips Left", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Leg Circles to High Skips to Side Skips Right", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Pepper knees to Forward Runs", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Base Rotation to Base Rotations Runs", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Giant Wide Steps to Squat to Inchworm", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),

        // Dynamic Warm Up [Sports Set B]
        Exercise(name: "Forward Runs to Backward Runs to Leg Swings", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "High Knee Cross Touch to Knee Hug to Quad Stretch", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Slides to V-Shuffles to Side Leg Swings", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Mini-Hops to Carioca to Forward Runs", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Knee Turn Ins & Outs to Reverse Lunge with Side Reach", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Multi-Hip (Modified / Full) to 3-Point Stretch", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Squat + Ball Chest Pass to Sprint", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),

        // Dynamic Stretching Exercises
        Exercise(name: "Scapula Retraction and Protraction", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Arm Circles", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Shoulder Rotation", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Trunk Rotation", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Trunk Bending Cross Toe Touches", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Side Reach", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Standing Leg Curls", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Front Lunges", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Lunges", category: .warmup, durationSeconds: nil, sets: nil, reps: nil),

        // Machine Warm Up
        Exercise(name: "Bicycle Machine", category: .warmup, durationSeconds: 300, sets: nil, reps: nil),
        Exercise(name: "Rowing Machine", category: .warmup, durationSeconds: 300, sets: nil, reps: nil),
        Exercise(name: "Crosstrainer Machine", category: .warmup, durationSeconds: 300, sets: nil, reps: nil),

        // TO THE BEAT – Week 1 Strong Me (HUR Resistance Circuit Set 1)
        Exercise(name: "Leg Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Shuttle Runs", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Pull Down", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Wide Step Calf Raise", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Leg Curl", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Walking Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "BOSU Sitting Cable Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Push Up", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 2a Hearty Me (45s Sets, Basic Ankle Weights)
        Exercise(name: "Medicine Ball Bicep Curl", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Medicine Ball Overhead Triceps Extension", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "SUMO Squats", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lunge Step and Back", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Front Raises", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Side Raises", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Calf Raises", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Toe Raises", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Medicine Ball Chest Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Standing Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Leg Curls", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Leg Raises", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 2a Hearty Me (3min easy / 1min fast)
        Exercise(name: "Treadmill 3-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Interval Cycling", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Rowing Machine Intervals", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Jump Rope Intervals", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Treadmill Incline Walk", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE EXERCISES – Basic Core Circuit Set A2
        Exercise(name: "Abdominal Crunch Ball Throw", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Trunk Rotational Ball Throw", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Reverse Bridge Ball Chest Press", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Space Cat Ball Taps", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // CORE EXERCISES – Basic Core Circuit Set A3
        Exercise(name: "Fitball Abdominal Crunch", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Reverse Bridge", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Roll Out", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Front Planks", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 2b Hearty Me (Resistance Circuit Set 1b)
        Exercise(name: "Medicine Ball Lunge Trunk Rotation", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Slide Knee Touch", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Upright Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Front Step Up", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "SUMO Squat Calf Raises", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Triceps Dips", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Compass Run", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Eccentric Step Down Toe Touch", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Mini Split Jumps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Resistance Band Standing Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Standing Side Leg Raise", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Jog Sprint Intervals", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 2b Hearty Me (3min easy / 1min fast)
        Exercise(name: "Treadmill 3-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Basic Core Circuit Set B1
        Exercise(name: "Alternate Hand and Leg", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Rotational Abdominal Crunch", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Leg Balance Reverse Bridge Right", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Leg Balance Reverse Bridge Left", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Reverse Bridge March", category: .core, durationSeconds: nil, sets: nil, reps: nil),
         
        // CORE & FUN – Basic Core Circuit Set B2
        Exercise(name: "Burpees and Big Cat", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Plank Walk Out", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Boat V-Tuck", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Reverse Crunch", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Basic Core Circuit Set B3
        Exercise(name: "Side Leg Raise Right", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Leg Raise Left", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Clam Shell Right", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Clam Shell Left", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Prone Hip Extension Right", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Prone Hip Extension Left", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Supine Flutter Kick", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 3 Sporty Me (Agility Balance Coordination Metabolic Circuit Set 1a)
        Exercise(name: "Up and Go (Sitting or Lying Down)", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fast Foot Ladder", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Standing Broad Jump", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Burpees on the Move", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "High Knee Hurdle", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Hop Gallop Skip", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 3 Sporty Me (Sports Specific Circuit Set 1b)
        Exercise(name: "Soccer Step On", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Sole Roll", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dribbling Forward and Backward", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Soccer Step Over", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Step and Body Feint", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Step Tap", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 4a Rhythm and Me (HUR Resistance Circuit Set 1)
        Exercise(name: "HUR Leg Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Shuttle Runs", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Pull Down", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Wide Step Calf Raise", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Leg Curl", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Walking Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "BOSU Sitting Cable Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Shuttle Runs", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Wide Step Calf Raise", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Push Up", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Walking Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 4b Rhythm and Me (Just Jog Circuit)
        Exercise(name: "Incline Push Up with Slow and Fast Jog", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "SUMO Squat to High Knee Cross Touch with Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Resistance Band Upright Row with Slow and Fast Jog", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Bicep Curl to High Knee Cross Touch with Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Wide Step Calf Raise with Slow and Fast Jog", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Resistance Band Standing Row to High Knee Cross Touch with Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Triceps Extension with Slow and Fast Jog", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 5 Strong Me (HUR Resistance Circuit Set 2)
        Exercise(name: "HUR Single Leg Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Slide Knee Touch", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Chest Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Adductor", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Burpees", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Sitting Pull", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Slide Knee Touch", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Step Up to Single Leg Lunge", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Bench Dips", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Burpees", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 5 Cardio (machine continuous)
        Exercise(name: "Steady State Cycling", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Moderate Pace Rowing", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 5 Core Circuit
        Exercise(name: "Dance Aerobics Circuit: Wide Step Cross Back Lunge", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dance Aerobics Circuit: Diagonal Step to Star Step", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dance Aerobics Circuit: Single Arm Raises to Skating", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dance Aerobics Circuit: Single Arm Curl to Forward Step", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dance Aerobics Circuit: Forward Step to Fist Pumps", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dance Aerobics Circuit: Side Steps with Knocking", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 6 Hearty Me (Step Board Circuit)
        Exercise(name: "Side Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Push Up", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dips", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Leg Step Up with Medicine Ball Shoulder Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Split Jumps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Plank Jumps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 6 Hearty Me (Agility Balance Coordination Metabolic Circuit Set 4a)
        Exercise(name: "In and Out Taps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fast Foot Ladder Laterals", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Bear Crawling", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Shuffles", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Hop to Balance", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Ladder Runs Cone Touches", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 6 Hearty Me (3min easy / 1min fast)
        Exercise(name: "Treadmill 3-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 7 Sporty Me (Agility Balance Coordination Metabolic Circuit Set 2a)
        Exercise(name: "Square Drills (Quick Shuffle with Single Leg Balance)", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fast Foot Ladder Frontal", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Running Butt Kickers", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Vertical Jumps on the Move", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Hurdle", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Carioca", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 7 Sporty Me (Sports Specific Circuit Set 2b)
        Exercise(name: "Lunge to Lift", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "4 Corners Footwork", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Forward Step to Reverse Wood Chop", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Medicine Ball Trunk Rotation with Medicine Ball Slam", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Jump over Dome Marker", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Leg Balance on Foam with Racket", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 8a Rhythm and Me (Gymstick and Resistance Band Circuit)
        Exercise(name: "Chest Press and Standing Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "SUMO Squat and Lateral Shuffles", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Upright Row and Shoulder Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Bicep Curl and Overhead Triceps Extension", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lunge with Trunk Rotation and Marching", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Front Raise and Standing Reverse Fly", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 8a Rhythm and Me (machine intervals)
        Exercise(name: "Treadmill 3-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Interval Cycling", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Rowing Machine Intervals", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 8a Core Circuit
        Exercise(name: "Jack Knife with Single Leg Half Squats", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Push Ups with Squat Jumps", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Shuttle Runs with Dumbbell Front Raises", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Medicine Ball Slam with Forward Lunges", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Hamstring Curls with Burpees", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Calf Raises with Step Board Dips", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Roach Legs with Scissor Jumps", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "High Knee Runs with Dumbbell Side Raises", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 8b Rhythm and Me (NAPFA Set A)
        Exercise(name: "V-Sit Ball Bounce to Dumbbell Calf Raise", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Biceps Curl Shoulder Press with Step Board Jump", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "V-Shuffles with Flex Arm Hang", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Abdominal Crunches with Rear Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Ball Passes with Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Multi Directional Hops with Dumbbell Upright Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Alternate Hand Leg with Vertical Jumps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Bounding with Medicine Triceps Extension", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 8b Rhythm and Me (machine intervals)
        Exercise(name: "Treadmill 2-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 8b Core Circuit
        Exercise(name: "V-Sit Ball Bounce to Dumbbell Calf Raise", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Biceps Curl Shoulder Press with Step Board Jump", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "V-Shuffles with Flex Arm Hang", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Abdominal Crunches with Rear Lunges", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Ball Passes with Jumping Jacks", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Multi Directional Hops with Dumbbell Upright Row", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Alternate Hand Leg with Vertical Jumps", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Bounding with Medicine Triceps Extension", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 9 Strong Me (HUR Resistance Circuit Set 3)
        Exercise(name: "HUR Single Leg Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Walking Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Chest Press", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Isometric Push Up Hold", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Leg Curl", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Step Up to Single Leg Balance", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Push Up", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Medicine Ball Triceps Extension", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Squat and Cable Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Squat Jumps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "HUR Sitting Pull", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Biceps Curl", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 9 Cardio (machine continuous)
        Exercise(name: "Steady State Cycling", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Moderate Pace Rowing", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 9 Core Circuit
        Exercise(name: "Dance Aerobics Circuit: Wide Step Cross Back Lunge", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Diagonal Step to Star Step", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Arm Raises to Skating", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Arm Curl to Forward Step", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Forward Step to Fist Pumps", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Steps with Knocking", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 10 Hearty Me (Dance Aerobics Circuit)
        Exercise(name: "Wide Step Cross Back Lunge", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Diagonal Step to Star Step", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Arm Raises to Skating", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Arm Curl to Forward Step", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Forward Step to Fist Pumps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Steps with Knocking", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 10 Cardio (machine intervals)
        Exercise(name: "Treadmill 2-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 10 Core Circuit
        Exercise(name: "Incline Push Up with Slow and Fast Jog", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "SUMO Squat to High Knee Cross Touch with Jumping Jacks", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Resistance Band Upright Row with Slow and Fast Jog", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Bicep Curl to High Knee Cross Touch with Jumping Jacks", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Wide Step Calf Raise with Slow and Fast Jog", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Resistance Band Standing Row to High Knee Cross Touch with Jumping Jacks", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Dumbbell Triceps Extension with Slow and Fast Jog", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 11 Sporty Me (Agility Balance Coordination Metabolic Circuit Set 3a)
        Exercise(name: "On 4s Hip Flexion", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fast Foot Ladder Lateral", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Striding", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Block on the Move", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Jumping Over Hurdle", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Bounding", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 11 Sporty Me (Sports Specific Circuit Set 3b)
        Exercise(name: "Single Hand Dribbling Stationary", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Figure 8 Dribbling Static or Dynamic", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Chest Pass or Bounce Pass", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Ball Overhead Wrist Flicks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Shoulder Rotator Cuffs", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Single Leg Balance Body Push", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 11 Cardio (machine continuous)
        Exercise(name: "Steady State Cycling", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 11 Core Circuit
        Exercise(name: "Square Drills (Quick Shuffle with Single Leg Balance)", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fast Foot Ladder Frontal", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Running Butt Kickers", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Vertical Jumps on the Move", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Hurdle", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Carioca", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 12a Rhythm and Me (Body Weight Circuit)
        Exercise(name: "Wide Push Ups to Narrow Push Ups with Triceps Dips", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Medicine Ball Biceps Curl Shoulder with Bear Walking", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Plank to Push Ups with Torso Rotation", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Mini Hops with SUMO Squats to Single Leg Balance", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Standing Single Leg Clockwork to Plank Hip Abduction", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lunge to Single Leg Balance and Hop with 5 Squats and 1 1 Jump", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 12a Cardio (machine intervals)
        Exercise(name: "Treadmill 1-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 12a Core Circuit
        Exercise(name: "Wide Push Ups to Narrow Push Ups with Triceps Dips", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Medicine Ball Biceps Curl Shoulder with Bear Walking", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Plank to Push Ups with Torso Rotation", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Mini Hops with SUMO Squats to Single Leg Balance", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Standing Single Leg Clockwork to Plank Hip Abduction", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lunge to Single Leg Balance and Hop with 5 Squats and 1 1 Jump", category: .core, durationSeconds: nil, sets: nil, reps: nil),

        // TO THE BEAT – Week 12b Rhythm and Me (NAPFA Set B)
        Exercise(name: "V-Sit Ball Bounce to Dumbbell Calf Raise", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Biceps Curl Shoulder Press with Step Board Jump", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "V-Shuffles with Flex Arm Hang", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Abdominal Crunches with Rear Lunges", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Ball Passes with Jumping Jacks", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Multi Directional Hops with Dumbbell Upright Row", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Alternate Hand Leg with Vertical Jumps", category: .strength, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Bounding with Medicine Triceps Extension", category: .strength, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 12b Cardio (machine intervals)
        Exercise(name: "Treadmill 1-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE & FUN – Week 12b Core Circuit
        Exercise(name: "V-Sit Ball Bounce to Dumbbell Calf Raise", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Biceps Curl Shoulder Press with Step Board Jump", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "V-Shuffles with Flex Arm Hang", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Abdominal Crunches with Rear Lunges", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Ball Passes with Jumping Jacks", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Multi Directional Hops with Dumbbell Upright Row", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Alternate Hand Leg with Vertical Jumps", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Lateral Bounding with Medicine Triceps Extension", category: .core, durationSeconds: nil, sets: nil, reps: nil),
         
        // HUFF & PUFF – Week 1 Cardio Intervals
        Exercise(name: "Shuttle Run 20m", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Treadmill 3-min Easy / 1-min Fast", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Agility Ladder Circuit", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Bear Crawl Relay", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Hop-Gallop-Skip Circuit", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // HUFF & PUFF – Week 2 Cardio Intervals
        Exercise(name: "Interval Cycling", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Rowing Machine Intervals", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Jump Rope Intervals", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Treadmill Incline Walk", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Step Aerobics", category: .cardio, durationSeconds: nil, sets: nil, reps: nil),

        // CORE EXERCISES – Week 1 Core Circuit
        Exercise(name: "Front Plank to Plank Jumps", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Side Plank (Left to Right)", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Fitball Roll-out to Reverse Crunch", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Boat Pose to V-tuck", category: .core, durationSeconds: nil, sets: nil, reps: nil),
        Exercise(name: "Supine Flutter Kick to Clam Shell", category: .core, durationSeconds: nil, sets: nil, reps: nil),
    ]
    
    static func prunedExerciseList() -> ([Exercise], [Exercise], [Exercise], [Exercise], [Exercise]) {
        let warmup = allExercises.filter { $0.category == .warmup }.shuffled().prefix(15)
        let strength = allExercises.filter { $0.category == .strength }.shuffled().prefix(15)
        let cardio = allExercises.filter { $0.category == .cardio }.shuffled().prefix(15)
        let core = allExercises.filter { $0.category == .core }.shuffled().prefix(15)
        return ((warmup + strength + cardio + core).shuffled(), warmup.shuffled(), strength.shuffled(), cardio.shuffled() , core.shuffled())
//        return Array(warmup+strength+cardio+core)
    }
    
    static let intelligenceInstructions = """
    You are Sharon, a friendly, upbeat virtual coach and motivator for adolescents enrolled in the SingHealth‑KKH training programme for obesity. Always provide positive affirmation to the patient, even when results are not the best. Offer personalized exercise prescription and encouragement based on the patient's progress and the available exercise catalogue. When giving the overview of the exercises the patient will do, do so in a fun and snappy way. You are talking to an actual human. NEVER include any markdown such as '**' stars or bullet points, only raw string. Format should be like 'So first off, you will be doing ..., and then ...'. When giving feedback and recommendations, you should advocate for a healthy balanced diet, lots of sleep, and daily movement.
    
    In the session statistics string, the most important metrics to look at are the effort score (0-100) - especially compared to the previous effort score if it exists, max heart rate and calories burned. Perceived exertion (0 = easy - 10 = very tired) is a subjective measure of how tiring an exercise phase felt. Do not just list these metrics when giving the overview, make it more motivating and fun. No need to always give exact values either (NO DECIMALS), just express if something was positive and how good it was. NEVER mistake 'perceived effort score' for 'effort score' since they are entirely different.
    """
}
