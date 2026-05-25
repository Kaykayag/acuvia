// lib/features/learn/presentation/screens/learn_data.dart
import 'package:flutter/material.dart';

class LearnSubItem {
  final String title;
  final IconData icon;
  final List<LearnSection> sections;

  const LearnSubItem({
    required this.title,
    required this.icon,
    required this.sections,
  });
}

class LearnSection {
  final String heading;
  final String body;
  final List<String>? bullets;

  const LearnSection({
    required this.heading,
    required this.body,
    this.bullets,
  });
}

class LearnCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<LearnSubItem> subItems;

  const LearnCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.subItems,
  });
}

class LearnData {
  static final List<LearnCategory> categories = [
    // ─── SYMPTOM LIBRARY ───────────────────────────────────────────────────────
    LearnCategory(
      title: 'Symptom Library',
      subtitle: 'Detailed information about common symptoms',
      icon: Icons.monitor_heart_outlined,
      color: const Color(0xFF2B7FFF),
      subItems: [
        LearnSubItem(
          title: 'Fever',
          icon: Icons.thermostat_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Fever?',
              body:
                  'A fever is a temporary rise in body temperature, often due to an illness. '
                  'A temperature above 38°C (100.4°F) is generally considered a fever. '
                  'It is a natural immune response that helps the body fight infections.',
            ),
            const LearnSection(
              heading: 'Common Causes',
              body: '',
              bullets: [
                'Viral infections (flu, COVID-19, common cold)',
                'Bacterial infections (pneumonia, UTI, strep throat)',
                'Inflammatory conditions (rheumatoid arthritis)',
                'Heat exhaustion or heat stroke',
                'Certain medications (drug-induced fever)',
                'Vaccinations (mild short-term fever)',
              ],
            ),
            const LearnSection(
              heading: 'Symptoms to Watch',
              body: '',
              bullets: [
                'Body temperature > 38°C (100.4°F)',
                'Chills and shivering',
                'Sweating',
                'Headache and muscle aches',
                'Loss of appetite',
                'Dehydration and fatigue',
              ],
            ),
            const LearnSection(
              heading: 'When to Seek Help',
              body: 'Seek immediate care if fever exceeds 39.4°C (103°F), '
                  'lasts more than 3 days, is accompanied by stiff neck, '
                  'severe headache, rash, difficulty breathing, or confusion.',
            ),
            const LearnSection(
              heading: 'Home Management',
              body: '',
              bullets: [
                'Stay hydrated — drink water, clear broths, electrolyte drinks',
                'Rest adequately',
                'Use a cool, damp cloth on forehead',
                'Take paracetamol or ibuprofen as directed',
                'Wear light, breathable clothing',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Chest Pain',
          icon: Icons.favorite_border,
          sections: [
            const LearnSection(
              heading: 'Overview',
              body:
                  'Chest pain can range from a dull ache to a sharp stabbing sensation. '
                  'It may be felt in the chest, neck, jaw, shoulders, or arms. '
                  'While it can have many causes, it should always be taken seriously as it may indicate a cardiac emergency.',
            ),
            const LearnSection(
              heading: 'Possible Causes',
              body: '',
              bullets: [
                'Heart attack (myocardial infarction)',
                'Angina (reduced blood flow to the heart)',
                'Pulmonary embolism (blood clot in lung)',
                'Pneumonia or pleuritis',
                'Gastroesophageal reflux (GERD)',
                'Costochondritis (rib cartilage inflammation)',
                'Panic attacks or anxiety',
                'Muscle strain',
              ],
            ),
            const LearnSection(
              heading: 'Warning Signs of a Heart Attack',
              body: '',
              bullets: [
                'Pressure, squeezing, or crushing chest pain',
                'Pain radiating to arm, jaw, neck, or back',
                'Shortness of breath',
                'Cold sweat, nausea, or lightheadedness',
                'Sudden fatigue without exertion',
              ],
            ),
            const LearnSection(
              heading: 'Immediate Action',
              body: 'If you suspect a heart attack, call emergency services (911/local number) immediately. '
                  'Chew one aspirin (325 mg) if not allergic. '
                  'Do not drive yourself to the hospital. Stay calm and rest until help arrives.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Shortness of Breath',
          icon: Icons.air_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Dyspnea?',
              body:
                  'Shortness of breath (dyspnea) is the uncomfortable sensation of not being able to breathe easily. '
                  'It can come on suddenly or develop gradually and may occur at rest or with activity.',
            ),
            const LearnSection(
              heading: 'Common Causes',
              body: '',
              bullets: [
                'Asthma or COPD',
                'Pneumonia or bronchitis',
                'Heart failure',
                'Pulmonary embolism',
                'Anemia (low red blood cells)',
                'Anxiety or panic attacks',
                'COVID-19 or severe flu',
                'Allergic reaction or anaphylaxis',
              ],
            ),
            const LearnSection(
              heading: 'Emergency Signs',
              body: 'Call emergency services immediately if shortness of breath is sudden and severe, '
                  'accompanied by chest pain, blue lips or fingertips (cyanosis), '
                  'confusion, or inability to complete a sentence.',
            ),
            const LearnSection(
              heading: 'Management Tips',
              body: '',
              bullets: [
                'Sit upright or lean slightly forward',
                'Use prescribed inhalers if available',
                'Practice pursed-lip breathing',
                'Remove yourself from allergens or smoke',
                'Seek medical attention promptly',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Headache',
          icon: Icons.psychology_outlined,
          sections: [
            const LearnSection(
              heading: 'Types of Headaches',
              body: '',
              bullets: [
                'Tension headache — dull, pressure-like pain around the head',
                'Migraine — throbbing pain, often one-sided, with nausea/light sensitivity',
                'Cluster headache — severe pain around one eye in clusters',
                'Sinus headache — pressure around eyes, cheeks, forehead',
                'Secondary headache — caused by another condition (hypertension, infection)',
              ],
            ),
            const LearnSection(
              heading: 'Common Triggers',
              body: '',
              bullets: [
                'Stress and anxiety',
                'Dehydration',
                'Poor posture or eye strain',
                'Hormonal changes',
                'Bright lights, loud noise',
                'Caffeine or alcohol',
                'Skipping meals',
              ],
            ),
            const LearnSection(
              heading: 'Red Flag Symptoms',
              body: 'Seek emergency care for a "thunderclap" headache (worst of your life), '
                  'headache with fever + stiff neck (possible meningitis), '
                  'headache after head trauma, or headache with vision changes or weakness.',
            ),
            const LearnSection(
              heading: 'Relief Measures',
              body: '',
              bullets: [
                'Rest in a dark, quiet room',
                'Apply cold or warm compress to forehead/neck',
                'Stay hydrated',
                'Over-the-counter pain relievers (paracetamol, ibuprofen)',
                'Practice relaxation or deep breathing',
              ],
            ),
          ],
        ),
      ],
    ),

    // ─── URGENCY LEVEL GUIDE ───────────────────────────────────────────────────
    LearnCategory(
      title: 'Urgency Level Guide',
      subtitle: 'Understanding triage levels and priorities',
      icon: Icons.crisis_alert_outlined,
      color: const Color(0xFFEF4444),
      subItems: [
        LearnSubItem(
          title: 'Level 1 — Immediate (Red)',
          icon: Icons.emergency_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Level 1?',
              body:
                  'Level 1 is the highest urgency. These are life-threatening conditions requiring '
                  'immediate resuscitation and intervention. Every minute counts. Call emergency services now.',
            ),
            const LearnSection(
              heading: 'Examples of Level 1 Conditions',
              body: '',
              bullets: [
                'Cardiac arrest — no pulse, not breathing',
                'Severe respiratory failure (oxygen saturation < 90%)',
                'Uncontrolled major hemorrhage',
                'Anaphylaxis (severe allergic reaction)',
                'Stroke with active neurological deficit',
                'Severe burns covering > 20% body surface',
                'Loss of consciousness / unresponsiveness',
                'Eclampsia in pregnancy',
              ],
            ),
            const LearnSection(
              heading: 'What To Do',
              body: '🚨 Call 911 (or local emergency number) immediately.\n'
                  'Start CPR if the person has no pulse and is not breathing.\n'
                  'Do not leave the patient alone. Send someone to flag down the ambulance.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Level 2 — Emergent (Orange)',
          icon: Icons.warning_amber_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Level 2?',
              body:
                  'Level 2 conditions are serious and potentially life-threatening. '
                  'The patient should be seen within 15 minutes. Delay can lead to rapid deterioration.',
            ),
            const LearnSection(
              heading: 'Examples of Level 2 Conditions',
              body: '',
              bullets: [
                'Chest pain with suspected cardiac cause',
                'Stroke symptoms (FAST: face drooping, arm weakness, speech difficulty)',
                'Severe asthma attack unresponsive to inhaler',
                'High fever (>40°C) with altered mental status',
                'Active seizure or postictal state',
                'Overdose or poisoning',
                'Severe allergic reaction (without airway compromise)',
                'Fracture with neurovascular compromise',
              ],
            ),
            const LearnSection(
              heading: 'What To Do',
              body: 'Go to the emergency room immediately or call an ambulance. '
                  'Do not wait. Monitor vital signs and keep the patient calm.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Level 3 — Urgent (Yellow)',
          icon: Icons.access_time_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Level 3?',
              body:
                  'Level 3 conditions are urgent but stable. The patient should be seen within 30 minutes. '
                  'These conditions require prompt attention but are not immediately life-threatening.',
            ),
            const LearnSection(
              heading: 'Examples of Level 3 Conditions',
              body: '',
              bullets: [
                'Moderate abdominal pain',
                'High fever (38.5–40°C) in adults',
                'Moderate shortness of breath',
                'Vomiting or diarrhea with dehydration',
                'Head injury with brief loss of consciousness',
                'Suspected fracture (limb stable, pulse present)',
                'Moderate allergic reaction (hives, swelling)',
                'Urinary tract infection with back pain',
              ],
            ),
            const LearnSection(
              heading: 'What To Do',
              body: 'Visit an urgent care clinic or emergency department. '
                  'Monitor symptoms closely. If condition worsens, escalate to Level 2.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Level 4 — Semi-Urgent (Green)',
          icon: Icons.check_circle_outline,
          sections: [
            const LearnSection(
              heading: 'What is Level 4?',
              body:
                  'Level 4 conditions are semi-urgent. The patient can wait up to 1 hour. '
                  'These are generally stable conditions that need medical attention but are unlikely to deteriorate rapidly.',
            ),
            const LearnSection(
              heading: 'Examples of Level 4 Conditions',
              body: '',
              bullets: [
                'Minor lacerations or wounds requiring sutures',
                'Ear infection or ear pain',
                'Urinary symptoms without back pain',
                'Minor sprains or strains',
                'Mild-moderate headache',
                'Eye irritation or conjunctivitis',
                'Nausea/vomiting without dehydration',
                'Dental pain',
              ],
            ),
            const LearnSection(
              heading: 'What To Do',
              body: 'Visit a clinic or urgent care. '
                  'A same-day doctor appointment is appropriate. '
                  'Monitor and escalate if symptoms worsen.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Level 5 — Non-Urgent (Blue)',
          icon: Icons.info_outline,
          sections: [
            const LearnSection(
              heading: 'What is Level 5?',
              body:
                  'Level 5 conditions are non-urgent and can be addressed within 2 hours or at a scheduled appointment. '
                  'These are minor, chronic, or administrative concerns.',
            ),
            const LearnSection(
              heading: 'Examples of Level 5 Conditions',
              body: '',
              bullets: [
                'Common cold without complications',
                'Prescription refill requests',
                'Minor rashes without systemic symptoms',
                'Chronic condition follow-up',
                'Mild sore throat',
                'Minor skin conditions (acne, dry skin)',
                'Routine immunization questions',
                'Lab result inquiries',
              ],
            ),
            const LearnSection(
              heading: 'What To Do',
              body: 'Schedule a routine appointment with your primary care physician. '
                  'Telehealth or online consultation is often appropriate for Level 5 concerns.',
            ),
          ],
        ),
      ],
    ),

    // ─── FIRST AID GUIDES ─────────────────────────────────────────────────────
    LearnCategory(
      title: 'First Aid Guides',
      subtitle: 'Step-by-step emergency response instructions',
      icon: Icons.health_and_safety_outlined,
      color: const Color(0xFF22C55E),
      subItems: [
        LearnSubItem(
          title: 'CPR (Cardiopulmonary Resuscitation)',
          icon: Icons.favorite_outlined,
          sections: [
            const LearnSection(
              heading: 'When to Perform CPR',
              body:
                  'Perform CPR when a person is unresponsive and not breathing normally (or only gasping). '
                  'CPR keeps blood and oxygen flowing to the brain and vital organs until emergency help arrives.',
            ),
            const LearnSection(
              heading: 'Step-by-Step: Adult CPR',
              body: '',
              bullets: [
                "1. Check the scene for safety, then tap the person's shoulder and shout 'Are you okay?'",
                '2. Call 911 (or ask someone to call) and get an AED if available',
                '3. Lay the person on their back on a firm, flat surface',
                '4. Tilt head back, lift chin — open the airway',
                '5. Check for breathing for no more than 10 seconds',
                '6. Place heel of one hand on center of chest (lower half of breastbone)',
                '7. Place your other hand on top, interlace fingers',
                '8. Push hard and fast — compress at least 5 cm (2 inches) deep',
                '9. Allow full chest recoil between compressions',
                '10. Rate: 100–120 compressions per minute ("Stayin\' Alive" tempo)',
                '11. Give 2 rescue breaths after every 30 compressions (if trained)',
                '12. Continue until AED arrives, patient recovers, or EMS takes over',
              ],
            ),
            const LearnSection(
              heading: 'Hands-Only CPR',
              body:
                  'If you are untrained or uncomfortable with rescue breaths, '
                  'perform continuous chest compressions without breaths. '
                  'This is still highly effective for adults in cardiac arrest.',
            ),
            const LearnSection(
              heading: 'CPR for Children (1–8 years)',
              body: '',
              bullets: [
                'Use one hand or two fingers for compressions',
                'Compress to about 5 cm (2 inches) or 1/3 of chest depth',
                'Give 2 gentle rescue breaths after every 30 compressions',
                'Rate: 100–120 compressions per minute',
              ],
            ),
            const LearnSection(
              heading: 'AED Use',
              body: 'Turn on the AED and follow voice prompts. '
                  'Attach pads to bare chest as shown. '
                  'Ensure no one is touching the person when AED analyzes or delivers shock. '
                  'Resume CPR immediately after shock.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Choking (Heimlich Maneuver)',
          icon: Icons.no_food_outlined,
          sections: [
            const LearnSection(
              heading: 'Recognizing Choking',
              body: '',
              bullets: [
                'Unable to speak, cry, or breathe',
                'Making high-pitched wheezing sounds',
                'Clutching throat with hands (universal choking sign)',
                'Turning blue (cyanosis) in the lips or face',
                'Weak or ineffective cough',
              ],
            ),
            const LearnSection(
              heading: 'Heimlich Maneuver — Adults & Children > 1 year',
              body: '',
              bullets: [
                '1. Ask "Are you choking?" — if they can\'t speak, act immediately',
                '2. Stand behind the person, slightly to one side',
                '3. Give 5 firm back blows between the shoulder blades with the heel of your hand',
                '4. If object not dislodged, move to abdominal thrusts',
                '5. Make a fist with one hand, place thumb side against abdomen just above navel',
                '6. Grasp fist with other hand',
                '7. Give 5 quick inward-and-upward thrusts',
                '8. Alternate 5 back blows and 5 abdominal thrusts until object is expelled',
                '9. If person becomes unconscious, begin CPR',
              ],
            ),
            const LearnSection(
              heading: 'Choking Infant (< 1 year)',
              body: '',
              bullets: [
                '1. Hold infant face-down on your forearm, head lower than chest',
                '2. Give 5 gentle but firm back blows with heel of hand',
                '3. Turn infant face-up, supporting head',
                '4. Give 5 chest thrusts with 2 fingers on center of chest',
                '5. Alternate until object is expelled or infant becomes unresponsive',
                '6. If unresponsive, begin infant CPR and call 911',
              ],
            ),
            const LearnSection(
              heading: 'Self-Heimlich (Alone)',
              body: '',
              bullets: [
                'Make a fist and place it above your navel',
                'Grasp fist with other hand and thrust inward and upward',
                'Or thrust your abdomen sharply against a hard edge (table, chair back)',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Severe Bleeding',
          icon: Icons.bloodtype_outlined,
          sections: [
            const LearnSection(
              heading: 'Assessing Severity',
              body:
                  'Severe bleeding is life-threatening. An adult can lose consciousness '
                  'from blood loss within minutes. Act quickly and calmly.',
            ),
            const LearnSection(
              heading: 'Step-by-Step Control',
              body: '',
              bullets: [
                '1. Protect yourself — wear gloves if available',
                '2. Apply firm direct pressure to the wound with a clean cloth or bandage',
                '3. Do NOT remove the cloth if soaked — add more on top',
                '4. Maintain continuous pressure for at least 10–15 minutes',
                '5. Elevate the injured limb above heart level if possible',
                '6. If extremity bleeding is life-threatening and pressure fails, apply a tourniquet',
                '7. Place tourniquet 5–8 cm above the wound (never on a joint)',
                '8. Tighten until bleeding stops, note the time applied',
                '9. Do not remove the tourniquet — leave for medical personnel',
                '10. Call 911 immediately',
              ],
            ),
            const LearnSection(
              heading: 'Wounds to Avoid Direct Pressure',
              body: '',
              bullets: [
                'Embedded objects — do NOT remove; stabilize the object',
                'Eye injuries — use a protective cup, not direct pressure',
                'Head wounds with suspected skull fracture — gentle pressure only',
              ],
            ),
            const LearnSection(
              heading: 'Signs of Shock',
              body: 'Watch for: pale/cold/clammy skin, rapid weak pulse, confusion, dizziness, or fainting. '
                  'Lay the person flat, elevate legs (unless spinal injury suspected), keep warm, and call 911.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Burns',
          icon: Icons.local_fire_department_outlined,
          sections: [
            const LearnSection(
              heading: 'Burn Classification',
              body: '',
              bullets: [
                '1st Degree — Superficial: red, dry, painful (like sunburn)',
                '2nd Degree — Partial thickness: blisters, intense pain, wet appearance',
                '3rd Degree — Full thickness: white/brown/black, leathery, may be painless (nerve damage)',
                '4th Degree — Extends to bone/muscle; always an emergency',
              ],
            ),
            const LearnSection(
              heading: 'Immediate Steps',
              body: '',
              bullets: [
                '1. Remove the person from the source of burn',
                '2. Cool the burn with cool (not cold/ice) running water for 20 minutes',
                '3. Remove jewelry and clothing near the burn (unless stuck to skin)',
                '4. Cover loosely with a clean, non-fluffy dressing or cling film',
                '5. Do NOT apply butter, toothpaste, ice, or any home remedies',
                '6. Do NOT pop blisters',
                '7. Give pain relief (paracetamol or ibuprofen) if needed',
              ],
            ),
            const LearnSection(
              heading: 'When to Call 911',
              body: '',
              bullets: [
                'Burns covering > 1% of the body (palm-size) in a child',
                'Any 3rd or 4th degree burn',
                'Burns to face, hands, feet, genitals, or major joints',
                'Chemical or electrical burns',
                'Burns with suspected inhalation injury (singed nasal hair, hoarse voice)',
                'Burns in elderly, infants, or immunocompromised individuals',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Stroke (FAST Response)',
          icon: Icons.bolt_outlined,
          sections: [
            const LearnSection(
              heading: 'The FAST Method',
              body: 'Time is brain. Every minute of stroke = ~1.9 million neurons lost. '
                  'Use the FAST acronym to identify a stroke quickly:',
              bullets: [
                '🅕 Face — Ask to smile. Is one side drooping?',
                '🅐 Arms — Ask to raise both arms. Does one drift downward?',
                '🅢 Speech — Ask to repeat a sentence. Is speech slurred or strange?',
                '🅣 Time — If any sign: call 911 IMMEDIATELY. Note time symptoms started.',
              ],
            ),
            const LearnSection(
              heading: 'Additional Warning Signs',
              body: '',
              bullets: [
                'Sudden severe headache with no known cause',
                'Sudden vision problems in one or both eyes',
                'Sudden numbness or weakness in leg',
                'Sudden confusion or trouble understanding',
                'Loss of balance or coordination',
              ],
            ),
            const LearnSection(
              heading: 'What NOT To Do',
              body: '',
              bullets: [
                'Do NOT give food or water (swallowing may be impaired)',
                'Do NOT give aspirin unless directed by 911 dispatcher',
                'Do NOT let the person "sleep it off"',
                'Do NOT drive them yourself — call an ambulance',
              ],
            ),
            const LearnSection(
              heading: 'While Waiting for Help',
              body: '',
              bullets: [
                'Keep the person calm and still',
                'Lay them down with head and shoulders slightly raised',
                'If unconscious and breathing: recovery position',
                'If not breathing: begin CPR',
                'Loosen any restrictive clothing',
              ],
            ),
          ],
        ),
      ],
    ),

    // ─── DISEASE AWARENESS ────────────────────────────────────────────────────
    LearnCategory(
      title: 'Disease Awareness',
      subtitle: 'Learn about common medical conditions',
      icon: Icons.coronavirus_outlined,
      color: const Color(0xFF8B5CF6),
      subItems: [
        LearnSubItem(
          title: 'Diabetes Mellitus',
          icon: Icons.water_drop_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Diabetes?',
              body:
                  'Diabetes mellitus is a chronic condition where the body cannot properly regulate blood glucose. '
                  'Type 1 involves the immune system destroying insulin-producing cells. '
                  'Type 2 involves insulin resistance and is largely lifestyle-related. '
                  'Gestational diabetes occurs during pregnancy.',
            ),
            const LearnSection(
              heading: 'Common Symptoms',
              body: '',
              bullets: [
                'Frequent urination (polyuria)',
                'Excessive thirst (polydipsia)',
                'Unexplained weight loss',
                'Extreme hunger',
                'Blurry vision',
                'Slow-healing sores',
                'Frequent infections',
                'Fatigue and irritability',
              ],
            ),
            const LearnSection(
              heading: 'Risk Factors for Type 2',
              body: '',
              bullets: [
                'Overweight or obesity (BMI > 25)',
                'Physical inactivity',
                'Family history of diabetes',
                'Age > 45 years',
                'High blood pressure or cholesterol',
                'History of gestational diabetes',
                'Polycystic ovary syndrome (PCOS)',
              ],
            ),
            const LearnSection(
              heading: 'Complications if Unmanaged',
              body: '',
              bullets: [
                'Heart disease and stroke',
                'Kidney failure (diabetic nephropathy)',
                'Nerve damage (diabetic neuropathy)',
                'Eye damage and blindness (retinopathy)',
                'Foot ulcers and amputation',
                'Diabetic ketoacidosis (DKA) — medical emergency',
              ],
            ),
            const LearnSection(
              heading: 'Management',
              body: '',
              bullets: [
                'Monitor blood glucose regularly',
                'Take prescribed medications (metformin, insulin, etc.)',
                'Follow a balanced low-GI diet',
                'Exercise at least 150 minutes per week',
                'Maintain healthy weight',
                'Regular HbA1c checks every 3 months',
                'Annual eye, kidney, and foot exams',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Hypertension',
          icon: Icons.speed_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Hypertension?',
              body:
                  'Hypertension (high blood pressure) occurs when the force of blood against artery walls '
                  'is consistently too high (≥ 130/80 mmHg). It is often called the "silent killer" '
                  'because it typically has no symptoms until serious damage has occurred.',
            ),
            const LearnSection(
              heading: 'Blood Pressure Classifications',
              body: '',
              bullets: [
                'Normal: < 120/80 mmHg',
                'Elevated: 120–129 / < 80 mmHg',
                'Stage 1 Hypertension: 130–139 / 80–89 mmHg',
                'Stage 2 Hypertension: ≥ 140 / ≥ 90 mmHg',
                'Hypertensive Crisis: > 180 / > 120 mmHg — seek emergency care',
              ],
            ),
            const LearnSection(
              heading: 'Risk Factors',
              body: '',
              bullets: [
                'Obesity or overweight',
                'High sodium diet',
                'Physical inactivity',
                'Heavy alcohol use',
                'Smoking',
                'Chronic stress',
                'Family history',
                'Age (risk increases with age)',
                'Diabetes or kidney disease',
              ],
            ),
            const LearnSection(
              heading: 'Lifestyle Changes',
              body: '',
              bullets: [
                'DASH diet (fruits, vegetables, low-fat dairy, whole grains)',
                'Reduce sodium to < 2,300 mg/day',
                'Exercise 30 minutes most days',
                'Limit alcohol to ≤ 1 drink/day (women) or ≤ 2 drinks/day (men)',
                'Quit smoking',
                'Manage stress (meditation, yoga)',
                'Monitor BP at home regularly',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Asthma',
          icon: Icons.air_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Asthma?',
              body:
                  'Asthma is a chronic inflammatory airway disease causing recurrent episodes of wheezing, '
                  'breathlessness, chest tightness, and coughing. Airways become swollen and produce excess mucus, '
                  'making breathing difficult.',
            ),
            const LearnSection(
              heading: 'Common Triggers',
              body: '',
              bullets: [
                'Allergens (pollen, dust mites, pet dander, mold)',
                'Air pollution, smoke, and fumes',
                'Respiratory infections (cold, flu)',
                'Exercise (exercise-induced bronchoconstriction)',
                'Cold air',
                'Strong emotions or stress',
                'Medications (aspirin, NSAIDs, beta-blockers)',
                'Occupational exposures (chemicals, dust)',
              ],
            ),
            const LearnSection(
              heading: 'Asthma Action Plan',
              body: '',
              bullets: [
                'GREEN ZONE (feeling good): take controller medication daily',
                'YELLOW ZONE (symptoms worsening): use rescue inhaler, consult doctor',
                'RED ZONE (severe symptoms): use rescue inhaler immediately, seek emergency care',
              ],
            ),
            const LearnSection(
              heading: 'Using a Metered-Dose Inhaler (MDI)',
              body: '',
              bullets: [
                '1. Shake inhaler for 5 seconds',
                '2. Exhale fully',
                '3. Place mouthpiece in mouth, seal lips',
                '4. Press canister while breathing in slowly (3–5 seconds)',
                '5. Hold breath for 10 seconds',
                '6. Wait 30–60 seconds before second puff',
                'Always use a spacer for better drug delivery',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Dengue Fever',
          icon: Icons.bug_report_outlined,
          sections: [
            const LearnSection(
              heading: 'What is Dengue?',
              body:
                  'Dengue fever is a mosquito-borne viral infection (Aedes aegypti mosquito) common in tropical '
                  'and subtropical regions including Southeast Asia. It can progress to severe dengue (dengue hemorrhagic fever) '
                  'which can be fatal.',
            ),
            const LearnSection(
              heading: 'Symptoms',
              body: '',
              bullets: [
                'Sudden high fever (39–40°C)',
                'Severe headache',
                'Pain behind the eyes (retro-orbital pain)',
                'Muscle and joint pain ("breakbone fever")',
                'Nausea and vomiting',
                'Skin rash (appears 2–5 days after fever)',
                'Mild bleeding (nose, gums)',
              ],
            ),
            const LearnSection(
              heading: 'Warning Signs of Severe Dengue',
              body: 'Seek emergency care immediately for:',
              bullets: [
                'Abdominal pain or tenderness',
                'Persistent vomiting',
                'Rapid breathing',
                'Bleeding from gums or nose',
                'Blood in vomit or stool',
                'Fatigue, restlessness, or irritability',
                'Skin becomes cold and clammy',
              ],
            ),
            const LearnSection(
              heading: 'Management',
              body: '',
              bullets: [
                'No specific antiviral treatment — supportive care',
                'Rest and adequate hydration (ORS, coconut water)',
                'Paracetamol for fever — NEVER aspirin or ibuprofen',
                'Monitor platelet count daily',
                'Hospital admission if warning signs appear',
                'Mosquito prevention: eliminate standing water, use repellent, wear long sleeves',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'COVID-19',
          icon: Icons.coronavirus_outlined,
          sections: [
            const LearnSection(
              heading: 'Overview',
              body:
                  'COVID-19 is caused by the SARS-CoV-2 virus, primarily spreading through respiratory droplets '
                  'and aerosols. It can range from asymptomatic to severe illness requiring hospitalization.',
            ),
            const LearnSection(
              heading: 'Common Symptoms',
              body: '',
              bullets: [
                'Fever or chills',
                'Cough (dry or productive)',
                'Shortness of breath',
                'Fatigue',
                'Muscle or body aches',
                'Headache',
                'Loss of taste or smell (anosmia/ageusia)',
                'Sore throat',
                'Nausea, vomiting, or diarrhea',
              ],
            ),
            const LearnSection(
              heading: 'Emergency Warning Signs',
              body: '',
              bullets: [
                'Trouble breathing',
                'Persistent chest pain or pressure',
                'New confusion',
                'Inability to wake or stay awake',
                'Bluish lips or face',
              ],
            ),
            const LearnSection(
              heading: 'Prevention',
              body: '',
              bullets: [
                'Stay up to date with COVID-19 vaccinations and boosters',
                'Wear a well-fitting mask in high-risk settings',
                'Wash hands frequently with soap for 20 seconds',
                'Improve ventilation indoors',
                'Test when symptomatic or after exposure',
                'Isolate if positive to protect others',
              ],
            ),
          ],
        ),
      ],
    ),

    // ─── PREVENTION TIPS ──────────────────────────────────────────────────────
    LearnCategory(
      title: 'Prevention Tips',
      subtitle: 'Proactive health and wellness advice',
      icon: Icons.shield_outlined,
      color: const Color(0xFF06B6D4),
      subItems: [
        LearnSubItem(
          title: 'Nutrition & Healthy Eating',
          icon: Icons.restaurant_outlined,
          sections: [
            const LearnSection(
              heading: 'Foundations of a Healthy Diet',
              body:
                  'A balanced diet provides the energy and nutrients your body needs to function optimally. '
                  'No single food contains all nutrients — variety is key.',
            ),
            const LearnSection(
              heading: 'Daily Plate Guide',
              body: '',
              bullets: [
                '½ plate: fruits and vegetables (aim for color variety)',
                '¼ plate: whole grains (brown rice, oats, whole wheat)',
                '¼ plate: lean protein (fish, chicken, legumes, tofu)',
                'Include healthy fats: olive oil, avocado, nuts, seeds',
                'Choose low-fat dairy or dairy alternatives',
                'Drink 8–10 glasses of water daily',
              ],
            ),
            const LearnSection(
              heading: 'Foods to Limit',
              body: '',
              bullets: [
                'Ultra-processed foods (chips, instant noodles, packaged snacks)',
                'Sugary beverages (soda, sweetened juices)',
                'Red and processed meats',
                'Trans fats and partially hydrogenated oils',
                'Excessive sodium (> 2,300 mg/day)',
                'Added sugars (> 25g/day for women, > 36g/day for men)',
              ],
            ),
            const LearnSection(
              heading: 'Practical Tips',
              body: '',
              bullets: [
                'Meal prep on weekends to avoid unhealthy impulse choices',
                'Read nutrition labels — check serving sizes',
                'Eat mindfully — slow down, reduce distractions',
                'Don\'t skip breakfast — it stabilizes blood glucose',
                'Add fiber: helps digestion and reduces cholesterol',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Physical Activity',
          icon: Icons.directions_run_outlined,
          sections: [
            const LearnSection(
              heading: 'WHO Physical Activity Guidelines',
              body: '',
              bullets: [
                'Adults: 150–300 min/week moderate-intensity OR 75–150 min vigorous-intensity aerobic activity',
                'Plus muscle-strengthening activities ≥ 2 days/week',
                'Children 5–17: ≥ 60 min/day moderate-to-vigorous activity',
                'Older adults: add balance and fall prevention exercises',
              ],
            ),
            const LearnSection(
              heading: 'Types of Exercise',
              body: '',
              bullets: [
                'Aerobic (cardio): walking, jogging, cycling, swimming — improves heart and lung health',
                'Strength training: weights, resistance bands — builds muscle, improves metabolism',
                'Flexibility: yoga, stretching — reduces injury risk, improves posture',
                'Balance: tai chi, single-leg exercises — especially important for older adults',
                'HIIT: alternating high/low intensity — efficient calorie burn in short sessions',
              ],
            ),
            const LearnSection(
              heading: 'Getting Started',
              body: '',
              bullets: [
                'Start slow — even 10 minutes daily has benefits',
                'Choose activities you enjoy to stay consistent',
                'Track steps with a phone or wearable',
                'Take the stairs, walk or cycle short distances',
                'Schedule workouts like appointments — make them non-negotiable',
                'Warm up before and cool down after every session',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Sleep Hygiene',
          icon: Icons.bedtime_outlined,
          sections: [
            const LearnSection(
              heading: 'Why Sleep Matters',
              body:
                  'Sleep is essential for brain function, immune health, metabolism, and emotional wellbeing. '
                  'Chronic sleep deprivation increases risk of obesity, diabetes, cardiovascular disease, and mental health disorders.',
            ),
            const LearnSection(
              heading: 'Recommended Sleep Duration',
              body: '',
              bullets: [
                'Newborns (0–3 months): 14–17 hours',
                'School-age children (6–12 years): 9–12 hours',
                'Teenagers (13–18 years): 8–10 hours',
                'Adults (18–64 years): 7–9 hours',
                'Older adults (≥ 65 years): 7–8 hours',
              ],
            ),
            const LearnSection(
              heading: 'Sleep Hygiene Tips',
              body: '',
              bullets: [
                'Keep a consistent sleep schedule (same time, 7 days a week)',
                'Create a dark, cool, quiet sleep environment',
                'Avoid screens 60 minutes before bed (blue light suppresses melatonin)',
                'Avoid caffeine after 2 PM',
                'Avoid heavy meals within 2 hours of bedtime',
                'Limit alcohol — it disrupts sleep architecture',
                'Wind down with reading, meditation, or gentle stretching',
                'Reserve the bed for sleep and intimacy only',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Mental Health & Stress',
          icon: Icons.self_improvement_outlined,
          sections: [
            const LearnSection(
              heading: 'Understanding Stress',
              body:
                  'Stress is the body\'s response to perceived threats or demands. '
                  'Short-term stress can be motivating. Chronic stress is harmful and linked to heart disease, '
                  'depression, anxiety, and weakened immunity.',
            ),
            const LearnSection(
              heading: 'Signs of Chronic Stress',
              body: '',
              bullets: [
                'Persistent headaches or muscle tension',
                'Difficulty sleeping or sleeping too much',
                'Fatigue despite rest',
                'Difficulty concentrating',
                'Irritability, mood swings',
                'Social withdrawal',
                'Increased reliance on food, alcohol, or substances',
              ],
            ),
            const LearnSection(
              heading: 'Evidence-Based Coping Strategies',
              body: '',
              bullets: [
                'Regular physical exercise (reduces cortisol)',
                'Mindfulness meditation (10 min/day with apps like Headspace)',
                'Deep breathing: 4-7-8 technique (inhale 4s, hold 7s, exhale 8s)',
                'Journaling — write thoughts and feelings',
                'Social connection — talk to friends or family',
                'Set boundaries and learn to say no',
                'Professional help: therapist, counselor, or psychiatrist if needed',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Vaccination Schedule',
          icon: Icons.vaccines_outlined,
          sections: [
            const LearnSection(
              heading: 'Why Vaccinate?',
              body:
                  'Vaccines train your immune system to recognize and fight pathogens '
                  'without causing the actual disease. They protect individuals and create herd immunity '
                  'to protect vulnerable populations.',
            ),
            const LearnSection(
              heading: 'Adult Vaccines to Keep Current',
              body: '',
              bullets: [
                'Influenza (flu): annually every year',
                'COVID-19: initial series + updated boosters as recommended',
                'Tetanus-diphtheria (Td): booster every 10 years',
                'Tdap: once as an adult (covers pertussis)',
                'Hepatitis B: 3-dose series if not vaccinated',
                'Hepatitis A: 2-dose series (recommended for travelers)',
                'Pneumococcal (PCV15/PPSV23): adults ≥ 65 or high-risk',
                'Shingles (Shingrix): 2 doses for adults ≥ 50',
                'HPV: up to age 45 if not previously vaccinated',
              ],
            ),
            const LearnSection(
              heading: 'Vaccine Safety',
              body: 'Vaccines undergo rigorous safety testing before approval. '
                  'Common side effects (sore arm, mild fever) are normal immune responses '
                  'and resolve within 1–2 days. Severe reactions are extremely rare. '
                  'Benefits of vaccination far outweigh the risks.',
            ),
          ],
        ),
      ],
    ),

    // ─── WHEN TO SEEK HELP ───────────────────────────────────────────────────
    LearnCategory(
      title: 'When to Seek Help?',
      subtitle: 'Guidelines for appropriate medical attention',
      icon: Icons.help_outline,
      color: const Color(0xFFF97316),
      subItems: [
        LearnSubItem(
          title: 'Emergency Room (ER) — Go Now',
          icon: Icons.emergency_outlined,
          sections: [
            const LearnSection(
              heading: 'Go to the ER Immediately For:',
              body: '',
              bullets: [
                '🚨 Chest pain or pressure lasting > 2 minutes',
                '🚨 Difficulty breathing or shortness of breath at rest',
                '🚨 Signs of stroke (face drooping, arm weakness, speech difficulty)',
                '🚨 Uncontrolled bleeding',
                '🚨 Severe allergic reaction (throat swelling, hives + breathing difficulty)',
                '🚨 Loss of consciousness or unresponsiveness',
                '🚨 Seizure (first-time or prolonged > 5 minutes)',
                '🚨 Severe head, neck, or spine injury',
                '🚨 Overdose or poisoning',
                '🚨 Suicidal ideation or intent to harm self or others',
                '🚨 Fever > 40°C (104°F) with stiff neck and sensitivity to light',
                '🚨 Sudden severe headache (worst of your life)',
                '🚨 Coughing or vomiting blood',
                '🚨 Major burns or electrical injury',
              ],
            ),
            const LearnSection(
              heading: 'What to Bring to the ER',
              body: '',
              bullets: [
                'Government-issued ID and health insurance card',
                'List of current medications and allergies',
                'Brief medical history summary',
                'Emergency contact information',
                'Phone charger — ER waits can be long',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Urgent Care — Visit Today',
          icon: Icons.local_hospital_outlined,
          sections: [
            const LearnSection(
              heading: 'Urgent Care is Appropriate For:',
              body: '',
              bullets: [
                'Fever (38–39.4°C) without severe symptoms',
                'Minor cuts requiring stitches',
                'Sprains, strains, or suspected minor fractures',
                'Urinary tract infections',
                'Ear infections or sinus pain',
                'Pink eye (conjunctivitis)',
                'Minor burns or skin infections',
                'Vomiting or diarrhea with mild dehydration',
                'Back pain without neurological symptoms',
                'Asthma flare-up responding to rescue inhaler',
                'STI testing or exposure treatment',
              ],
            ),
            const LearnSection(
              heading: 'Urgent Care vs ER',
              body:
                  'Urgent care is faster and cheaper for non-life-threatening issues. '
                  'If your condition is deteriorating rapidly or involves vital signs or consciousness, '
                  'always choose the ER.',
            ),
          ],
        ),
        LearnSubItem(
          title: 'Primary Care Doctor — Schedule Soon',
          icon: Icons.person_outlined,
          sections: [
            const LearnSection(
              heading: 'Schedule a Doctor Visit For:',
              body: '',
              bullets: [
                'Persistent cough > 3 weeks',
                'Unexplained weight loss or gain',
                'Fatigue lasting weeks without clear cause',
                'New or changing skin lesions or moles',
                'Regular health screenings (blood pressure, cholesterol, blood sugar)',
                'Pap smears, mammograms, or prostate exams',
                'Mental health concerns (depression, anxiety)',
                'Prescription refills or medication reviews',
                'Chronic condition management (diabetes, hypertension)',
                'Immunizations and vaccines',
              ],
            ),
            const LearnSection(
              heading: 'Preventive Screenings by Age',
              body: '',
              bullets: [
                'Adults 18+: Blood pressure check annually',
                'Adults 35+ (or earlier if risk factors): Fasting blood glucose',
                'Adults 40+: Cholesterol panel every 5 years',
                'Women 21+: Pap smear every 3 years',
                'Women 40+: Mammogram annually',
                'Adults 45+: Colorectal cancer screening',
                'Adults 50+: Bone density scan (especially women)',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Telehealth — Consult Remotely',
          icon: Icons.video_call_outlined,
          sections: [
            const LearnSection(
              heading: 'Telehealth is Great For:',
              body: '',
              bullets: [
                'Cold, flu, or COVID-19 symptoms (mild)',
                'Prescription refills for stable chronic conditions',
                'Mental health therapy and counseling sessions',
                'Rash or skin issue evaluation (photos)',
                'Medication questions or side effects',
                'Follow-up after recent clinic visit',
                'General health questions and advice',
                'Nutritional or lifestyle counseling',
              ],
            ),
            const LearnSection(
              heading: 'Not Suitable for Telehealth',
              body: '',
              bullets: [
                'Any condition requiring physical examination',
                'Emergency symptoms',
                'New chest pain',
                'Conditions requiring laboratory or imaging tests',
              ],
            ),
            const LearnSection(
              heading: 'Tips for a Good Telehealth Visit',
              body: '',
              bullets: [
                'Choose a quiet, private, well-lit room',
                'Test your internet connection and camera beforehand',
                'Have a list of medications and symptoms ready',
                'Take your vitals if possible (temperature, blood pressure)',
                'Write down your questions in advance',
              ],
            ),
          ],
        ),
        LearnSubItem(
          title: 'Mental Health — When to Reach Out',
          icon: Icons.psychology_outlined,
          sections: [
            const LearnSection(
              heading: 'Seek Help If You Experience:',
              body: '',
              bullets: [
                'Persistent sadness or emptiness lasting > 2 weeks',
                'Loss of interest in activities you once enjoyed',
                'Significant changes in sleep or appetite',
                'Difficulty functioning at work, school, or relationships',
                'Panic attacks or overwhelming anxiety',
                'Hearing or seeing things others do not',
                'Thoughts of self-harm or suicide',
                'Substance use that feels out of control',
                'Extreme mood swings',
              ],
            ),
            const LearnSection(
              heading: 'Crisis Resources',
              body: '',
              bullets: [
                '🆘 Philippines: Crisis Line — 1553 (DOH)',
                '🆘 International: Befrienders Worldwide — befrienders.org',
                '🆘 Crisis Text Line: Text HOME to 741741 (US)',
                'You are not alone. Help is available 24/7.',
              ],
            ),
            const LearnSection(
              heading: 'Breaking the Stigma',
              body:
                  'Mental health conditions are medical conditions — not weaknesses or character flaws. '
                  'Seeking help is a sign of strength. Early intervention leads to better outcomes. '
                  'Talk to a trusted person, a doctor, or a mental health professional today.',
            ),
          ],
        ),
      ],
    ),
  ];
  
  static Null get s => null;
}