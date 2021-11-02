namespace :courses do
  desc 'TODO'
  task seed_courses: :environment do
    course_subjects = {
      'Civil Engineering':
        ['Algebra', 'Plane Trigonometry', 'Spherical Trigonometry', 'Analytic Geometry', 'Descriptive Geometry', 'Solid Geometry', 'Differential Calculus', 'Integral Calculus', 'Highway and Railroad Surveying', 'Advance Surveying', 'Fluid properties', 'Hydrostatic Pressures', 'Fluid Flow', 'Bouyancy and Flotation', 'Relative Equilibrium of Liquids', 'Hydrodynamics', 'Water Supply', 'Soil Properties', 'Soil Classification', 'Fluid Through Soil Mass', 'Stresses in soil mass', 'Soil strength and Test', 'Bearing Capacity', 'Compaction', 'Consolidation and Settlement', 'Lateral Earth pressures', 'Slope Stability', 'Engineering Mechanics', 'Strength of materials', 'Theory of Structures', 'Analysis and Design of Concrete Structures', 'Analysis and Design of Steel Structures', 'Analysis and Design of Timber Structures', 'Analysis and Design of Foundation'],
      Psychology:
        ['Advanced Theories of Personality', 'Advanced Abnormal Psychology', 'Advanced Psychological Assessment', 'Psychological Counseling and Psychotherapy'],
      Nursing:
        ['Community Health Nursing', 'Care of Healthy/At Risk Mother and Child', 'Care of Clients with Physiologic and Psychosocial Alterations (Part A)', 'Care of Clients with Physiologic and Psychosocial Alterations (Part B)', 'Care of Clients with Physiologic and Psychosocial Alterations (Part C)']
    }

    course_subjects.each do |course_name, subjects|
      course = Course.where(name: course_name).first_or_create!
      subjects.each do |subject|
        course.subjects.where(name: subject).first_or_create!
      end
    end

    puts "#{course_subjects.count} courses has been updated."
  end
end
