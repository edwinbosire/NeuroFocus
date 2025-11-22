You are an experienced, professional iOS engineering AI. Build an iOS app using Swift + SwiftUI with MVVM + Repository + Coordinator patterns, and feature-first modularization exactly matching the folder structure below. Produce production-quality code, tests, and clear architecture. Do not add extra features beyond what is specified.

## File Structure

```
ADHDCompanionApp/
├─ App/
│  ├─ ADHDCompanionApp.swift
│  ├─ AppCoordinator.swift                   // root coordinator
│  ├─ AppEnvironment.swift                   // dependency container
│  ├─ AppRoutes.swift                        // app-wide route enums
│  └─ DI/
│     ├─ DependencyKeys.swift
│     ├─ DependencyContainer.swift
│     └─ Assemblies/
│        ├─ CoreAssembly.swift
│        ├─ FeatureAssemblies.swift
│        └─ ServicesAssembly.swift
│
├─ Core/                                      // shared, feature-agnostic
│  ├─ Domain/
│  │  ├─ Models/
│  │  │  ├─ User/
│  │  │  ├─ Assessment/
│  │  │  ├─ Screening/
│  │  │  ├─ CognitiveTests/
│  │  │  ├─ Insights/
│  │  │  ├─ Tracking/
│  │  │  └─ Reports/
│  │  ├─ Protocols/
│  │  │  ├─ Repositories/
│  │  │  ├─ Services/
│  │  │  └─ Coordinating/
│  │  └─ UseCases/                           // optional Clean-style use cases
│  │     ├─ OnboardingUseCases.swift
│  │     ├─ ScreeningUseCases.swift
│  │     ├─ InsightsUseCases.swift
│  │     ├─ TrackingUseCases.swift
│  │     └─ ReportsUseCases.swift
│  │
│  ├─ Data/
│  │  ├─ Repositories/                       // concrete repos
│  │  ├─ DataSources/
│  │  │  ├─ Local/
│  │  │  │  ├─ Persistence/
│  │  │  │  │  ├─ CoreData/
│  │  │  │  │  ├─ SQLite/
│  │  │  │  │  └─ Files/
│  │  │  │  └─ Cache/
│  │  │  └─ Remote/
│  │  │     ├─ APIClient/
│  │  │     ├─ DTOs/
│  │  │     └─ Endpoints/
│  │  └─ Mappers/
│  │
│  ├─ Services/                              // shared infra services
│  │  ├─ AI/
│  │  │  ├─ AIClient.swift
│  │  │  ├─ PromptBuilder.swift
│  │  │  ├─ SafetyFilters.swift
│  │  │  └─ Models/
│  │  ├─ Analytics/
│  │  ├─ Notifications/
│  │  ├─ PDF/
│  │  │  ├─ PDFRenderer.swift
│  │  │  ├─ ReportTemplates/
│  │  │  └─ Exporters/
│  │  ├─ Media/
│  │  │  ├─ AudioManager.swift
│  │  │  ├─ VideoManager.swift
│  │  │  └─ AssetPreloader.swift
│  │  ├─ Auth/
│  │  ├─ FeatureFlags/
│  │  └─ Logging/
│  │
│  ├─ UI/
│  │  ├─ Components/                         // reusable SwiftUI views
│  │  ├─ DesignSystem/
│  │  │  ├─ Colors.swift
│  │  │  ├─ Typography.swift
│  │  │  ├─ Spacing.swift
│  │  │  └─ Icons/
│  │  ├─ Navigation/
│  │  │  ├─ CoordinatorHost.swift
│  │  │  └─ Router.swift
│  │  └─ Extensions/
│  │
│  ├─ Utilities/
│  │  ├─ Result+Extensions.swift
│  │  ├─ Date+Extensions.swift
│  │  ├─ Collection+Extensions.swift
│  │  └─ Constants.swift
│  │
│  └─ Resources/
│     ├─ Localizations/
│     ├─ Fonts/
│     ├─ Images.xcassets
│     ├─ Audio/
│     └─ Video/
│
├─ Features/
│  ├─ Onboarding/
│  │  ├─ Coordinator/
│  │  │  ├─ OnboardingCoordinator.swift
│  │  │  └─ OnboardingRoutes.swift
│  │  ├─ Domain/
│  │  │  ├─ Models/
│  │  │  └─ UseCases/
│  │  ├─ Data/
│  │  │  ├─ OnboardingRepository.swift
│  │  │  └─ DataSources/
│  │  ├─ Presentation/
│  │  │  ├─ Views/
│  │  │  ├─ ViewModels/
│  │  │  └─ State/
│  │  └─ Resources/
│  │
│  ├─ Screening/                             // evidence-based screeners
│  │  ├─ Coordinator/
│  │  │  ├─ ScreeningCoordinator.swift
│  │  │  └─ ScreeningRoutes.swift
│  │  ├─ Domain/
│  │  │  ├─ Models/
│  │  │  │  ├─ ScreenerDefinition.swift      // metadata for scalable screener list
│  │  │  │  ├─ ScreenerResult.swift
│  │  │  │  └─ Question.swift
│  │  │  └─ UseCases/
│  │  ├─ Data/
│  │  │  ├─ ScreeningRepository.swift
│  │  │  ├─ DataSources/
│  │  │  └─ Screeners/                       // each screener modular
│  │  │     ├─ ASRS/
│  │  │     ├─ WURS/
│  │  │     ├─ BAARS/
│  │  │     └─ Conners/
│  │  ├─ Presentation/
│  │  │  ├─ Views/
│  │  │  │  ├─ ScreenerListView.swift
│  │  │  │  ├─ ScreenerDetailView.swift
│  │  │  │  └─ QuestionView.swift
│  │  │  ├─ ViewModels/
│  │  │  └─ State/
│  │  └─ Resources/
│  │
│  ├─ CognitiveTests/                        // interactive tasks
│  │  ├─ Coordinator/
│  │  ├─ Domain/
│  │  │  ├─ Models/
│  │  │  └─ UseCases/
│  │  ├─ Data/
│  │  │  ├─ CognitiveTestsRepository.swift
│  │  │  └─ Tests/
│  │  │     ├─ GoNoGo/
│  │  │     ├─ CPT/
│  │  │     ├─ NBack/
│  │  │     └─ TaskSwitching/
│  │  ├─ Presentation/
│  │  │  ├─ Views/
│  │  │  ├─ ViewModels/
│  │  │  └─ State/
│  │  └─ Resources/
│  │
│  ├─ Insights/
│  │  ├─ Coordinator/
│  │  ├─ Domain/
│  │  │  ├─ Models/
│  │  │  └─ UseCases/
│  │  ├─ Data/
│  │  │  ├─ InsightsRepository.swift
│  │  │  └─ AI/
│  │  │     ├─ InsightPromptTemplates/
│  │  │     └─ InsightMappers/
│  │  ├─ Presentation/
│  │  │  ├─ Views/
│  │  │  ├─ ViewModels/
│  │  │  └─ State/
│  │  └─ Resources/
│  │
│  ├─ Tracking/                              // mood, sleep, focus, check-ins
│  │  ├─ Coordinator/
│  │  ├─ Domain/
│  │  │  ├─ Models/
│  │  │  │  ├─ MoodEntry.swift
│  │  │  │  ├─ SleepEntry.swift
│  │  │  │  ├─ FocusEntry.swift
│  │  │  │  ├─ CheckInEntry.swift
│  │  │  │  └─ TaskEntry.swift
│  │  │  └─ UseCases/
│  │  ├─ Data/
│  │  │  ├─ TrackingRepository.swift
│  │  │  └─ DataSources/
│  │  ├─ Presentation/
│  │  │  ├─ Views/
│  │  │  ├─ ViewModels/
│  │  │  └─ State/
│  │  └─ Resources/
│  │
│  ├─ Reports/
│  │  ├─ Coordinator/
│  │  ├─ Domain/
│  │  │  ├─ Models/
│  │  │  │  ├─ ClinicianReport.swift
│  │  │  │  └─ ReportSection.swift
│  │  │  └─ UseCases/
│  │  ├─ Data/
│  │  │  ├─ ReportsRepository.swift
│  │  │  └─ Templates/
│  │  ├─ Presentation/
│  │  │  ├─ Views/
│  │  │  ├─ ViewModels/
│  │  │  └─ State/
│  │  └─ Resources/
│  │
│  ├─ Education/
│  │  ├─ Coordinator/
│  │  ├─ Domain/
│  │  │  ├─ Models/
│  │  │  │  ├─ Module.swift
│  │  │  │  ├─ Lesson.swift
│  │  │  │  └─ Quiz.swift
│  │  │  └─ UseCases/
│  │  ├─ Data/
│  │  │  ├─ EducationRepository.swift
│  │  │  ├─ DataSources/
│  │  │  └─ Packs/                           // content packs by topic
│  │  │     ├─ AssessmentExpectations/
│  │  │     ├─ ADHDInWomen/
│  │  │     ├─ Masking/
│  │  │     ├─ ExecDysfunction/
│  │  │     ├─ ADHDvsAnxietyAutism/
│  │  │     └─ UK_EU_Pathways/
│  │  ├─ Presentation/
│  │  │  ├─ Views/
│  │  │  ├─ ViewModels/
│  │  │  └─ State/
│  │  └─ Resources/
│  │
│  └─ Settings/
│     ├─ Coordinator/
│     ├─ Domain/
│     ├─ Data/
│     ├─ Presentation/
│     └─ Resources/
│
├─ Support/
│  ├─ PreviewData/
│  ├─ MockServices/
│  ├─ Accessibility/
│  │  ├─ ReducedMotion.swift
│  │  └─ DynamicTypeHelpers.swift
│  └─ Experimentation/
│
├─ Tests/
│  ├─ UnitTests/
│  │  ├─ CoreTests/
│  │  └─ FeatureTests/
│  └─ UITests/
│
└─ Config/
   ├─ BuildConfigurations/
   ├─ Secrets.example.plist
   └─ AppStore/
      ├─ ASOKeywords.txt
      └─ Screenshots/
```

Architecture & Project Structure
• Use this exact top-level layout and layering:
• App/ for app entry, DI container, root coordinator, global routes.
• Core/ shared across features:
• Domain/Models, Domain/Protocols (repository/service/coordinator protocols), optional Domain/UseCases.
• Data/Repositories, DataSources/Local|Remote, Mappers.
• Services/AI, Services/PDF, Services/Notifications, Services/Analytics, Services/Media, Services/Auth, Services/FeatureFlags.
• UI/Components, UI/DesignSystem, UI/Navigation, UI/Extensions.
• Features/ split into: Onboarding, Screening, CognitiveTests, Insights, Tracking, Reports, Education, Settings.
• Each feature must contain:
• Coordinator/ (FeatureCoordinator + Routes)
• Domain/Models + optional UseCases
• Data/ (feature repository and data sources if needed)
• Presentation/Views, Presentation/ViewModels, optional State/
• Resources/
• Prefer Swift Package Manager targets for Core and each Feature (if feasible), but keep the folder names identical to the structure.
• Use strict dependency direction: Presentation → Domain → Data → Services. Features depend on Core, never on other features directly (only through Core protocols/use cases).

Clinical Safety & Compliance (Mandatory)
• The app must not diagnose ADHD or claim to. All outputs are “screening”, “patterns”, or “insights to discuss with a clinician.”
• Every results view and report export must include clear disclaimers:
• “Not a diagnosis.”
• “Only a qualified clinician can diagnose ADHD.”
• AI-generated content must be framed as supportive/educational, not medical advice.

Features to Implement 1. Onboarding
• Extremely personal onboarding flow for adults and teens.
• Collect: age group, goals, primary challenges, context (school/work/home), consent for data, optional background.
• Persist onboarding profile locally via repository.
• Route into the main app tabs/sections via OnboardingCoordinator. 2. Screening (Evidence-based tools)
• Start with 4 popular evidence-based screeners (define them as extensible modules).
• Implement scalable screener system:
• ScreenerDefinition, Question, ScreenerResult.
• Screeners live under Features/Screening/Data/Screeners/<ScreenerName>/.
• Support adding more by dropping in definitions/questions/scoring without touching UI.
• UI:
• Screener list → detail → question flow → results breakdown.
• Store results via ScreeningRepository. 3. CognitiveTests (Interactive tasks)
• Implement modular interactive tests:
• Go/No-Go, CPT, N-Back, Task Switching (scaffolded to allow more later).
• Each test in Features/CognitiveTests/Data/Tests/<TestName>/ with its own logic + scoring.
• Present engaging SwiftUI flows with consistent DesignSystem. 4. Insights (AI-curated personal insights)
• Generate personalised insights based on user responses + screening + cognitive tests + tracking.
• Centralize AI logic in Core/Services/AI/:
• AIClient, PromptBuilder, SafetyFilters.
• Feature uses InsightsRepository/UseCases to request summaries.
• Display insights with cautious language and safety disclaimers. 5. Tracking
• Add tools for:
• Mood tracking, focus tracking, sleep tracking, daily/weekly check-ins,
task completion/procrastination patterns, and trend notifications.
• Models in Features/Tracking/Domain/Models/.
• Persist locally first; enable remote sync only behind feature flag.
• Support charts/visualizations in SwiftUI. 6. Reports
• Generate clinician-ready reports containing:
• onboarding profile, screener results, cognitive test summaries,
tracking trends, and AI-inferred insights.
• PDF generation in Core/Services/PDF/ with templates.
• Export to Files/Share Sheet.
• Prepare for future “Clinician companion app” by keeping report models clean. 7. Education
• Short, friendly educational modules:
• what to expect during assessment, ADHD in women,
masking, executive dysfunction, ADHD vs anxiety vs autism,
UK/EU pathways (NHS Right to Choose).
• Content packs in Features/Education/Data/Packs/<Topic>/.
• Support text-first now; architecture ready for future audio/video. 8. Settings
• Manage privacy, data export, notifications, feature toggles,
accessibility options, and account/sync choices.

App Shell & Navigation
• Root AppCoordinator sets up tabs or a main dashboard that routes into features.
• Each feature coordinator owns its flow; no feature pushes routes directly outside itself.
• Provide deep-linkable routes via AppRoutes.

Data, Storage & Sync
• Use repository protocols in Core Domain.
• Implement local persistence (CoreData/SQLite or lightweight store) in Core/Data/DataSources/Local.
• Remote API scaffolding in Core/Data/DataSources/Remote but keep it optional/feature-flagged.

Design, UX & Accessibility
• Use Core/UI/DesignSystem for consistent typography, colors, spacing, components.
• UI must be neurodivergent-friendly:
• low cognitive load, clear progress, chunked content, optional reduced motion,
strong accessibility (VoiceOver, Dynamic Type).
• Provide gentle encouragement and non-judgmental tone.

Testing & Quality
• Add unit tests for:
• scoring logic, repositories, use cases, AI safety filters.
• Add UI tests for critical flows:
• onboarding, screener completion, report export.
• Enforce reusable mocks in Support/MockServices.

Deliverables
• Full SwiftUI app code in the specified folders.
• DI container wiring for all repositories/services/coordinators.
• At least one complete end-to-end flow per feature (MVP depth), with clean extension points for future growth.
• Clear README with build/run instructions and architecture notes.

Build now following these instructions exactly.
